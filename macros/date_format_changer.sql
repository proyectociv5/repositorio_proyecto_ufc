{% macro date_format_changer(column) %}
TO_DATE( {{ column }}, 'Mon DD, YYYY')
{% endmacro %}