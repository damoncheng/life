from work import views
from django.conf.urls import url


urlpatterns = [
    url(r'home$', views.home, name="work_home"),
    url(r'teacher_course$', views.teacher_course, name="work_teacher_course"),
    url(r'^teacher_excel$', views.teacher_excel, name="work_teacher_excel"),
    url(r'^teach_teacher_excel$', views.teach_teacher_excel, name="work_teach_teacher_excel"),
]
