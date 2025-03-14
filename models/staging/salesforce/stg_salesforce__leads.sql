select
    /* Primary Key */
    {{ dbt_utils.generate_surrogate_key(['phone', 'loaded_at']) }} as lead_id,

    /* Foreign Keys */
    brightwheel_school_uuid_c as brightwheel_school_id,
    id as salesforce_id,
    mobile_phone,
    phone,

    /* Booleans */
    is_converted,
    case when email_bounced_date is null then true else false end as is_email_valid,

    /* Dates and Timestamps */
    created_date as created_at,
    last_modified_date as modified_at,

    /* Address */
    upper(street) as street,
    upper(city) as city,
    upper(state) as state,
    postal_code as zip,
    upper(concat(street,' ',city,' ',state,' ',postal_code)) as full_address

    /* Status and Properties */
    capacity_c as capacity,
    company as company_name,
    email,
    concat(first_name, ' ', last_name) as contact_name,
    lead_source,
    outreach_stage_c as outreach_stage,
    status as lead_status,

    /* Metadata */
    current_timestamp() as loaded_at

from {{ source('salesforce', 'leads') }}
where is_deleted = false
