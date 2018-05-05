# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.shortcuts import render, HttpResponse, HttpResponseRedirect

# Create your views here.
def request_split(request):
    print "------------attack test-----------"
    name = request.GET.get("name")
    print name
    test_ret = HttpResponseRedirect("http://www.baidu.com?name=" + name);
    print test_ret
    return HttpResponseRedirect("http://www.baidu.com?name=" + name)

def http_head(request):
    return HttpResponse("hello")


