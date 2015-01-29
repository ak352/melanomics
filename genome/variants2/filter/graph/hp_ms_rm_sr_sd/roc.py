import sys
from optparse import OptionParser
from pylab import *

def calculate(hists, value):
    tp = float(hists[0][-1] - hists[0][value])
    fn = float(hists[0][value])
    fp = float(hists[1][-1] - hists[1][value])
    tn = float(hists[1][value])
    tpr = tp/(tp+fn+0.00000000001)
    fpr = fp/(fp+tn+0.00000000001)
    mcc_num = (tp*tn) - (fp*fn)
    mcc_den = ((tp+fp)*(tp+fn)*(tn+fp)*(tn+fn))**0.5 + 0.00001
    mcc = mcc_num/mcc_den
    return tpr,fpr,mcc,tp

def remove_xlabels(ax):
    fig.canvas.draw()
    labels = [item.get_text() for item in ax.get_xticklabels()]
    for x in range(1, len(labels)-1):
        labels[x] = ""
    ax.set_xticklabels(labels)


def plot_roc_mcc(option, sample, truth_files, false_files, win_dimen, index, last_row, max_x, true_positive_thresh):
    attribute = option.attribute
    
    hist_true = [0]*option.max_thresh
    hist_false = [0]*option.max_thresh

    hists = [hist_true, hist_false]
    all_files = [truth_files, false_files]

    for i,all_file in enumerate(all_files):
        for infile in all_file:
            for line in open(infile):
                line = line[:-1].split("\t")
                hists[i][int(line[0])] += float(line[1])

    hists_freq = hists[:]
    for i,histogram in enumerate(hists):
        hists[i] = cumsum(histogram)

    #print hists
    offset_val, offset_rate = 0.2, 0.4

    tpr = [0]*option.max_thresh
    fpr = [0]*option.max_thresh
    mcc = [0]*option.max_thresh
    tp = [0]*option.max_thresh
    for k in range(option.max_thresh):
        tpr[k],fpr[k],mcc[k],tp[k] = calculate(hists, k)

    """ PLOT 1: Matthews correlation score """
    """ Need to get figure and axes to change axes labels """
    subplot(win_dimen[0],win_dimen[1],index+2)
    plot(range(len(mcc)), mcc, lw=3)

    """ Important: the MCC chosen is the maximum provided that the true positive > true_positive_thresh"""
    good_mcc = mcc[:]
    for i,m in enumerate(mcc):
        if tp[i]>=true_positive_thresh:
            good_mcc[i] = m
        else:
            good_mcc[i] = 0
    best_val = argmax(good_mcc)

    
    plot([best_val], mcc[best_val], "ro", markersize=10)
    #annotate("Filter value = %s\nMCC = %s" % (str(best_val), str(mcc[best_val])), xytext(best_val, mcc[best_val]-offset_val))
    annotate("Filter value = %d\nMCC = %4.3f" % (best_val, mcc[best_val]), xy=(best_val, mcc[best_val]), \
                 xytext=(0.8, 0.5), textcoords="axes fraction")
    if last_row:
        xlabel("Filter value")
        ylabel("Matthews correlation coefficient")
    ylim([-0.1,1])
    xlim([0, max_x])
    
    """ PLOT 2: ROC curve """
    subplot(win_dimen[0],win_dimen[1],index+1)
    plot(fpr, tpr, lw=3)
    if last_row:
        ylabel("True positive rate")
        xlabel("False positive rate")
    plot(fpr[best_val], tpr[best_val], "ro", markersize=10)
    # annotate("Filter value = %d\nTPR = %4.2f\nFPR = %4.2f" % (best_val, tpr[best_val], fpr[best_val]), (fpr[best_val], tpr[best_val]-offset_rate))
    annotate("Filter value = %d\nTPR = %4.2f\nFPR = %4.2f" % (best_val, tpr[best_val], fpr[best_val]), \
                 xy=(fpr[best_val], tpr[best_val]), \
                 xytext=(0.8, 0.3), textcoords="axes fraction")
    #xlim([0,1])
    #ylim([0,1])

    """ PLOT 3: Number of variants """
    subplot(win_dimen[0],win_dimen[1],index)
    plot(range(len(hists_freq[0])), hists_freq[0], "b", linewidth=3, label="concordant")
    plot(range(len(hists_freq[1])), hists_freq[1], "r", linewidth=3, label="discordant")
    plot([best_val], hists_freq[0][best_val], "go", markersize=10)
    plot([best_val], hists_freq[1][best_val], "go", markersize=10)
    xlim([0, max_x])
    if attribute == "coverage":
        sample_label = "patient_%s" % sample
    else:
        sample_label = sample
    if last_row:
        legend()
        xlabel("Filter value")
        ylabel("Number of variants\n%s" % sample)
    else:
        ylabel(sample)
        
    
    print "%s_%s\t%d\t%f\t%d" % (sample_label, attribute, best_val, mcc[best_val], tp[best_val])
    
if __name__ == "__main__":
    parser = OptionParser()
    parser.add_option("-t", "--truth", dest="truth_files", action="append", help="frequencies of true observations")
    parser.add_option("-f", "--false", dest="false_files", action="append", help="frequencies of false observations")
    parser.add_option("-m", "--max-thresh", type=int, dest="max_thresh", help="maximum threshold of parameter", default=200)
    parser.add_option("-a", "--attribute", type=str, dest="attribute", help="attribute such as coverage, quality etc.")
    parser.add_option("-s", "--sample", type=str, dest="sample", help="sample name")
    (option, args) = parser.parse_args()

    # DIR="/work/projects/melanomics/analysis/genome/variants2/filter/graphs/hp_ms_rm_sr_sd_absolute/"
    DIR="/work/projects/melanomics/analysis/genome/variants2/filter/graphs/hp_ms_rm_sr_sd_absolute_germline_only/"
    out_dir=DIR+"roc/"


    attributes = ["coverage", "snp.quality", "indelsub.quality", "NearestIndelDistance", "NearestHpDistance"]
    """ Max limit for x axis corresponding to the attributes"""
    max_x = [150, 30, 110, 110, 110]
    """ Minimum number of true positives required as a filtering constraint """
    true_positive_threshs = [1000000, 1000000, 100000, 1000000, 1000000]

    print "fields\tmin_thresh\tMCC\tTrue positives"

    for j, attrib in enumerate(attributes):
        option.attribute = attrib
        patients = [2,4,5,6,7,8]
        patients = ["p%d" % p for p in patients]
        win_dimen = (len(patients)*3*2, 3)
        figure(figsize=(32,60))
        
        index = 1
        suffixes = ["NS", "PM"]
        if attrib=="coverage":
            for i,p in enumerate(patients):
                for m,condition in enumerate(["normal", "tumor"]):
                    truth_files, false_files = ([] for i in range(2))
                    truth_files.extend(["%s%s.%s.concordant_%s.hist" % (DIR, p, attrib, condition)])
                    false_files.extend(["%s%s.%s.discordant_%s.hist" % (DIR, p, attrib, condition)])

            
            
            
                    sample = "%s_%s" % (p[1:], suffixes[m])
                    if i+1==len(patients) and j==1:
                        last_row = True
                    else:
                        last_row = False
                        plot_roc_mcc(option, sample, truth_files, false_files, win_dimen, index, last_row, max_x[j], true_positive_threshs[j])
                    index += 3
        else:
            for i,p in enumerate(patients):
                truth_files, false_files = ([] for i in range(2))
                truth_files.extend(["%s%s.%s.concordant_normal.hist" % (DIR, p, attrib)])
                truth_files.extend(["%s%s.%s.concordant_tumor.hist" % (DIR, p, attrib)])
                false_files.extend(["%s%s.%s.discordant_normal.hist" % (DIR, p, attrib)])
                false_files.extend(["%s%s.%s.discordant_tumor.hist" % (DIR, p, attrib)])
                sample = "patient_%s" % (p[1:])
                if i+1==len(patients):
                    last_row = True
                else:
                    last_row = False
                plot_roc_mcc(option, sample, truth_files, false_files, win_dimen, index, last_row, max_x[j], true_positive_threshs[j])
                index += 3
            
        filetypes = ['pdf', 'png', 'svg']
        for filetype in filetypes:
            outfile = '%s/%s.1.%s' % (out_dir, attrib, filetype)
            sys.stderr.write("Graph generated at %s\n" % outfile)
            savefig(outfile, bbox_inches='tight')


    #show()

