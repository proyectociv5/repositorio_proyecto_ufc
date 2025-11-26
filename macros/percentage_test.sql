{% test percentage_test(model, column_name) %}

   select *
   from {{ model }}
   where {{ column_name }} not between 0 and 100

{% endtest %}