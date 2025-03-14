with unioned_leads as (
    {{ dbt_utils.union_relations(
        relations=[
            ref('stg_third_party_leads__source1'), 
            ref('stg_third_party_leads__source2'),
            ref('stg_third_party_leads__source3')
        ]
    ) }}
)

lead_duplicate_checks as (
    select
        *,
        row_number() over (
            partition by phone
            order by loaded_at asc
        ) as phone_entered_order,
        row_number() over (
            partition by full_address
            order by loaded_at asc
        ) as address_entered_order,

    from unioned_leads
)

select
    /* Primary Key */
    lead_id,

    /* Foreign Key */
    phone,
    mobile_phone,

    /* Properties */
    full_address,
    capacity,
    company_name,
    email,
    contact_name,

    /* Lead Status */
    outreach_stage,
    lead_source,
    lead_status,
    case
        when phone_entered_order = 1 then 'New Phone'
        when phone_entered_order > 1 then 'Duplicate Phone'
    end as is_phone_duplicate,
    case
        when address_entered_order = 1 then 'New Address'
        when address_entered_order > 1 then 'Duplicate Address'
    end as is_phone_duplicate

from lead_duplicate_checks
