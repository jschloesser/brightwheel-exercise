select
    /* Primary Key */
    {{ dbt_utils.generate_surrogate_key(['phone', 'loaded_at']) }} as lead_id,

    /* Foreign Keys */
    cast(regexp_replace(phone, r"([^0-9])",'') as numeric) as phone,

    /* Address */
    upper(Address1) as street,
    upper(City) as city,
    upper(State) as state,
    Zip,
    upper(concat(Address1,' ',City,' ',State,' ',Zip)) as full_address

    /* Status and Properties */
    total_cap as capacity,
    company as company_name,
    rtrim(primary_caregiver, 'Primary Caregiver') as contact_name,
    'source2' as source_name,
    
    /* Metadata */
    current_timestamp() as loaded_at

from {{ source('third_party_leads', 'source2') }}
