import sys
from optparse import OptionParser
from pylab import *

def calculate(hists, value):
    tp = float(hists[0][-1] - hists[0][value])
    fn = float(hists[0][value])
    fp = float(hists[1][-1] - hists[1][value])
    tn = float(hists[1][value])
    tpr = tp/(tp+fn)
    fpr = fp/(fp+tn)
    mcc_num = (tp*tn) - (fp*fn)
    mcc_den = ((tp+fp)*(tp+fn)*(tn+fp)*(tn+fn))**0.5 + 0.00001
    mcc = mcc_num/mcc_den
    return tpr,fpr,mcc

def plot_roc_mcc(option, sample, truth_files, false_files, win_dimen, index, last_row):
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
    for k in range(option.max_thresh):
        tpr[k],fpr[k],mcc[k] = calculate(hists, k)

    subplot(win_dimen[0],win_dimen[1],index+2)
    plot(range(len(mcc)), mcc, lw=3)
    best_val = argmax(mcc)
    plot([best_val], mcc[best_val], "ro", markersize=10)
    annotate("Filter value = %s\nMCC = %s" % (str(best_val), str(mcc[best_val])), (best_val, mcc[best_val]-offset_val))
    if last_row:
        xlabel("Filter value")
        ylabel("Matthews correlation coefficient")
    ylim([-0.1,1])

    subplot(win_dimen[0],win_dimen[1],index+1)
    plot(fpr, tpr, lw=3)
    if last_row:
        ylabel("True positive rate")
        xlabel("False positive rate")
        title("ROC curve for %s for %s" %(attribute, sample))
    plot(fpr[best_val], tpr[best_val], "ro", markersize=10)
    annotate("Filter value = %s\nTPR = %s\nFPR = %s" % (str(best_val), str(tpr[best_val]), str(fpr[best_val])), (fpr[best_val], tpr[best_val]-offset_rate))
    #xlim([0,1])
    #ylim([0,1])

    subplot(win_dimen[0],win_dimen[1],index)
    plot(range(len(hists_freq[0])), hists_freq[0], "b", linewidth=3, label="concordant")
    plot(range(len(hists_freq[1])), hists_freq[1], "r", linewidth=3, label="discordant")
    plot([best_val], hists_freq[0][best_val], "go", markersize=10)
    plot([best_val], hists_freq[1][best_val], "go", markersize=10)
    if last_row:
        legend()
        xlabel("Filter value")
        ylabel("Number of variants\n%s" % sample)
    else:
        ylabel(sample)
        
    

    print "Filter value = %s\nMCC = %s" % (str(best_val), str(mcc[best_val]))
    print "Filter value = %s\nTPR = %s, FPR = %s" % (str(best_val), str(tpr[best_val]), str(fpr[best_val]))

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
    for attrib in attributes:
        option.attribute = attrib
        patients = [2,4,5,6,7,8]
        patients = ["p%d" % p for p in patients]
        win_dimen = (len(patients)*3, 3)
        figure(figsize=(32,50))
        
        index = 1
        for i,p in enumerate(patients):
            truth_files, false_files = ([] for i in range(2))
            truth_files.extend(["%s%s.%s.concordant_normal.hist" % (DIR, p, attrib)])
            truth_files.extend(["%s%s.%s.concordant_tumor.hist" % (DIR, p, attrib)])
            false_files.extend(["%s%s.%s.discordant_normal.hist" % (DIR, p, attrib)])
            false_files.extend(["%s%s.%s.discordant_tumor.hist" % (DIR, p, attrib)])
            
            
            
            sample = "patient_%s" % p[1:]
            if i+1==len(patients):
                last_row = True
            else:
                last_row = False
            plot_roc_mcc(option, sample, truth_files, false_files, win_dimen, index, last_row)
            index += 3
        savefig('%s/%s.pdf' % (out_dir, attrib), bbox_inches='tight')
        savefig('%s/%s.png' % (out_dir, attrib), bbox_inches='tight')
        savefig('%s/%s.svg' % (out_dir, attrib), bbox_inches='tight')

    #show()

