def get_samples():
    patients = [2,4,5,6,7,8]
    samples = ["NHEM"]
    samples.extend(["patient_%d_NS" % p for p in patients])
    samples.extend(["patient_%d_PM" % p for p in patients])
    samples.sort()
    return samples

