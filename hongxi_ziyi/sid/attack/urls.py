from django.conf.urls import url
from attack import views

urlpatterns = [
    #url(r'^admin', admin.site.urls),
    url(r'^request_split', views.request_split, name="request_split"),
    url(r'^http_head', views.http_head, name="http_head"),
]
