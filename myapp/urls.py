from django.urls import path
from . import views

urlpatterns = [
    path('createtables/', views.createTables)
    # ,path('executetriggers/',views.execute_triggers)
]