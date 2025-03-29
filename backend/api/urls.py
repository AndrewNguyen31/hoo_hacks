from django.urls import path
from . import views

urlpatterns = [
    path('process/', views.process_text, name='process_text'),
]