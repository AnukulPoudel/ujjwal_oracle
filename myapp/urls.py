from django.urls import path
from . import views

urlpatterns = [
    path('createtables/', views.createTables)
    ,path('handle/',views.handle)
]