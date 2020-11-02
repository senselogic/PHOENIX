<?php require __DIR__ . '/' . 'BLOCK/page_header_block.php' ?>
<div>
    <div class="page-section form-section">
        <form class="form-centered" action="/admin/comment/remove/<?php echo htmlspecialchars( $this->Comment->Id ); ?>" method="post">
            <div class="form-container">
                <div class="form-field-name">
                    Article Id :
                </div>
                <div>
                    <input class="form-input" name="ArticleId" type="text" value="<?php echo htmlspecialchars( $this->Comment->ArticleId ); ?>" readonly/>
                </div>
                <div class="form-field-name">
                    User Id :
                </div>
                <div>
                    <input class="form-input" name="UserId" type="text" value="<?php echo htmlspecialchars( $this->Comment->UserId ); ?>" readonly/>
                </div>
                <div class="form-field-name">
                    Text :
                </div>
                <div>
                    <textarea class="form-textarea" name="Text" readonly><?php echo htmlspecialchars( $this->Comment->Text ); ?></textarea>
                </div>
                <div class="form-field-name">
                    Date Time :
                </div>
                <div>
                    <input class="form-input" name="DateTime" type="text" value="<?php echo htmlspecialchars( $this->Comment->DateTime ); ?>" readonly/>
                </div>
                <a class="justify-self-start form-button form-button-large cancel-button" href="/admin/comment">
                </a>
                <button class="justify-self-end form-button-large form-button form-button-large remove-button" type="submit">
                </button>
            </div>
        </form>
    </div>
</div>
<?php require __DIR__ . '/' . 'BLOCK/page_footer_block.php' ?>
