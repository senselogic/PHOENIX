<?php require __DIR__ . '/' . 'BLOCK/page_header_block.php' ?>
<script>
    // -- FUNCTIONS

    function IsValidAddCommentForm()
    {
        var
            add_comment_form,
            it_is_valid_add_comment_form,
            article_id_field,
            user_id_field,
            text_field,
            date_time_field;

        it_is_valid_add_comment_form = true;

        add_comment_form = document.AddCommentForm;
        article_id_field = add_comment_form.ArticleId;
        user_id_field = add_comment_form.UserId;
        text_field = add_comment_form.Text;
        date_time_field = add_comment_form.DateTime;

        if ( article_id_field.value !== "" )
        {
            article_id_field.classList.remove( "form-field-error" );
        }
        else
        {
            article_id_field.classList.add( "form-field-error" );

            it_is_valid_add_comment_form = false;
        }

        if ( user_id_field.value !== "" )
        {
            user_id_field.classList.remove( "form-field-error" );
        }
        else
        {
            user_id_field.classList.add( "form-field-error" );

            it_is_valid_add_comment_form = false;
        }

        if ( text_field.value !== "" )
        {
            text_field.classList.remove( "form-field-error" );
        }
        else
        {
            text_field.classList.add( "form-field-error" );

            it_is_valid_add_comment_form = false;
        }

        if ( date_time_field.value !== "" )
        {
            date_time_field.classList.remove( "form-field-error" );
        }
        else
        {
            date_time_field.classList.add( "form-field-error" );

            it_is_valid_add_comment_form = false;
        }

        return it_is_valid_add_comment_form;
    }
</script>
<div>
    <div class="page-section form-section">
        <form class="form-centered" name="AddCommentForm" onsubmit="return IsValidAddCommentForm()" action="/admin/comment/add" method="post">
            <div class="form-container">
                <div class="form-field-name">
                    Article Id :
                </div>
                <div>
                    <input class="form-input" name="ArticleId" type="text"/>
                </div>
                <div class="form-field-name">
                    User Id :
                </div>
                <div>
                    <input class="form-input" name="UserId" type="text"/>
                </div>
                <div class="form-field-name">
                    Text :
                </div>
                <div>
                    <textarea class="form-textarea" name="Text"></textarea>
                </div>
                <div class="form-field-name">
                    Date Time :
                </div>
                <div>
                    <input class="form-input" name="DateTime" type="text"/>
                </div>
                <a class="justify-self-start form-button form-button-large cancel-button" href="/admin/comment">
                </a>
                <button class="justify-self-end form-button form-button-large apply-button" type="submit">
                </button>
            </div>
        </form>
    </div>
</div>
<?php require __DIR__ . '/' . 'BLOCK/page_footer_block.php' ?>
