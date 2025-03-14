select
    /* Primary Key */
    {{ dbt_utils.generate_surrogate_key(['phone', 'loaded_at']) }} as lead_id,

    /* Foreign Keys */
    cast(regexp_replace(phone, r"([^0-9])",'')as numeric) as phone,

    /* Address */
    address as full_address,
    state,

    /* Status and Properties */
    name as company_name,
    primary_contact_name as contact_name,
    'source3' as source_name,

    /* Metadata */
    current_timestamp() as loaded_at

from {{ source('third_party_leads', 'source1') }}
