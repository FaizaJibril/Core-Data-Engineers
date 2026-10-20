{#
    Runs at the end of every prod build (on-run-end in dbt_project.yml).
    Consumers (analysts, BI tools, AI agents) get read access to the marts schema only:
    staging and intermediate are internal building blocks, not a public interface.
    The Service Principal owns the marts schema, so it can grant on it. The schema-level
    grant also covers tables created later, so no per-table grants are needed.
#}
{% macro grant_marts_read_access(principal='account users') %}
    {% if execute and target.name == 'prod' %}
        {% set marts_schema = generate_schema_name('marts', none) %}
        {% do run_query("grant use schema, select on schema " ~ target.catalog ~ "." ~ marts_schema ~ " to `" ~ principal ~ "`") %}
        {% do log("Granted read on " ~ target.catalog ~ "." ~ marts_schema ~ " to " ~ principal, info=true) %}
    {% endif %}
{% endmacro %}
