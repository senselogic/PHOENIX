<?php require __DIR__ . '/' . 'BLOCK/page_header_block.php' ?>
<script>
    // -- FUNCTIONS

    function IsValidAddSubscriberForm()
    {
        var
            add_subscriber_form,
            it_is_valid_add_subscriber_form,
            email_field,
            ip_address_field,
            browser_field,
            latitude_field,
            longitude_field,
            country_code_field,
            date_time_field;

        it_is_valid_add_subscriber_form = true;

        add_subscriber_form = document.AddSubscriberForm;
        email_field = add_subscriber_form.Email;
        ip_address_field = add_subscriber_form.IpAddress;
        browser_field = add_subscriber_form.Browser;
        latitude_field = add_subscriber_form.Latitude;
        longitude_field = add_subscriber_form.Longitude;
        country_code_field = add_subscriber_form.CountryCode;
        date_time_field = add_subscriber_form.DateTime;

        if ( email_field.value !== "" )
        {
            email_field.classList.remove( "form-field-error" );
        }
        else
        {
            email_field.classList.add( "form-field-error" );

            it_is_valid_add_subscriber_form = false;
        }

        if ( ip_address_field.value !== "" )
        {
            ip_address_field.classList.remove( "form-field-error" );
        }
        else
        {
            ip_address_field.classList.add( "form-field-error" );

            it_is_valid_add_subscriber_form = false;
        }

        if ( browser_field.value !== "" )
        {
            browser_field.classList.remove( "form-field-error" );
        }
        else
        {
            browser_field.classList.add( "form-field-error" );

            it_is_valid_add_subscriber_form = false;
        }

        if ( latitude_field.value !== "" )
        {
            latitude_field.classList.remove( "form-field-error" );
        }
        else
        {
            latitude_field.classList.add( "form-field-error" );

            it_is_valid_add_subscriber_form = false;
        }

        if ( longitude_field.value !== "" )
        {
            longitude_field.classList.remove( "form-field-error" );
        }
        else
        {
            longitude_field.classList.add( "form-field-error" );

            it_is_valid_add_subscriber_form = false;
        }

        if ( country_code_field.value !== "" )
        {
            country_code_field.classList.remove( "form-field-error" );
        }
        else
        {
            country_code_field.classList.add( "form-field-error" );

            it_is_valid_add_subscriber_form = false;
        }

        if ( date_time_field.value !== "" )
        {
            date_time_field.classList.remove( "form-field-error" );
        }
        else
        {
            date_time_field.classList.add( "form-field-error" );

            it_is_valid_add_subscriber_form = false;
        }

        return it_is_valid_add_subscriber_form;
    }
</script>
<div>
    <div class="page-section form-section">
        <form class="form-centered" name="AddSubscriberForm" onsubmit="return IsValidAddSubscriberForm()" action="/admin/subscriber/add" method="post">
            <div class="form-container">
                <div class="form-field-name">
                    Email :
                </div>
                <div>
                    <input class="form-input" name="Email" type="text"/>
                </div>
                <div class="form-field-name">
                    Ip Address :
                </div>
                <div>
                    <input class="form-input" name="IpAddress" type="text"/>
                </div>
                <div class="form-field-name">
                    Browser :
                </div>
                <div>
                    <input class="form-input" name="Browser" type="text"/>
                </div>
                <div class="form-field-name">
                    Latitude :
                </div>
                <div>
                    <input class="form-input" name="Latitude" type="text"/>
                </div>
                <div class="form-field-name">
                    Longitude :
                </div>
                <div>
                    <input class="form-input" name="Longitude" type="text"/>
                </div>
                <div class="form-field-name">
                    Country Code :
                </div>
                <div>
                    <input class="form-input" name="CountryCode" type="text"/>
                </div>
                <div class="form-field-name">
                    Date Time :
                </div>
                <div>
                    <input class="form-input" name="DateTime" type="text"/>
                </div>
                <a class="justify-self-start form-button form-button-large cancel-button" href="/admin/subscriber">
                </a>
                <button class="justify-self-end form-button form-button-large apply-button" type="submit">
                </button>
            </div>
        </form>
    </div>
</div>
<?php require __DIR__ . '/' . 'BLOCK/page_footer_block.php' ?>
