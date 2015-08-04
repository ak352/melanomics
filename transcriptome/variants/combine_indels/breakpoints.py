def get_breakpoints(str1, str2):
    print str1, str2
    ref_str = str1
    if len(str1) > len(str2):
        str1, str2 = str2, str1
    (str_a, str_b) = (list(str1), list(str2))

    for x in range(0, len(str1)):
        print "str_a[", x, "] = ", str_a[x], "str_b[",x,"] = ", str_b[x]
        if str_a[x]!=str_b[x]:
            break
    left = x
    for x in range(-1, -len(str1)-1, -1):
        print "str_a[", x, "] = ", str_a[x], "str_b[",x,"] = ", str_b[x] 
        if str_a[x]!=str_b[x]:
            break

    
    right = len(ref_str)+x+1
    print left, right

    if left < right:
        return (left, right)
    if left == right:
        return (left, left + 1)
    if left > right:
        return (0, len(str1)+1)



if __name__ == "__main__":
    
    """Deletions"""
    (a, b) = get_breakpoints("TA", "TAA")
    assert (a,b) == (1, 2)
    print a, b
    (a, b) = get_breakpoints("TAC", "TC")
#    assert (a,b) == (0,2)
    print a, b
    (a, b) = get_breakpoints("TAC", "T")
    print a, b
    assert (a,b) == (0,3)
    (a, b) = get_breakpoints("CT", "C")
    print a, b
    assert (a,b) ==(0,2)
    
    """Insertions"""
    (a,b) = get_breakpoints("C", "CT")
    print a,b
    assert (a,b)==(0,1)
    (a,b) = get_breakpoints("CA", "CAT")
    assert (a,b)==(1,2)
    (a,b) = get_breakpoints("CT", "CAT")
    print (a,b)
    assert (a,b)==(0,2)
