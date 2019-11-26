<style>
    .sortable-column
    {
        cursor: pointer;
    }

    .sortable-column.order-is-ascending:after
    {
        position: absolute;
        content: "\00a0\25B2";
    }

    .sortable-column.order-is-descending:after
    {
        position: absolute;
        content: "\00a0\25BC";
    }
</style>
<script>
    $( document ).ready(
        function ()
        {
            var sortable_column_array = $( ".sortable-column" );

            sortable_column_array.each(
                function ( index )
                {
                    this.OrderIsDescending = ( this.classList.contains( "order-is-descending" ) >= 0 );
                }
                );

            sortable_column_array.click(
                function()
                {
                    function GetCellValue( row, cell_index )
                    {
                        return $( row ).children( "td" ).eq( cell_index ).text();
                    }

                    function GetCellComparison( cell_index, order_is_descending )
                    {
                        return (
                            function( first_row, second_row )
                            {
                                var cell_comparison = 0;
                                var first_cell_value = GetCellValue( first_row, cell_index ).trim();
                                var second_cell_value = GetCellValue( second_row, cell_index ).trim();

                                if ( $.isNumeric( first_cell_value )
                                     && $.isNumeric( second_cell_value ) )
                                {
                                    cell_comparison = first_cell_value - second_cell_value;
                                }
                                else if ( first_cell_value < second_cell_value )
                                {
                                    cell_comparison = -1;
                                }
                                else if ( first_cell_value > second_cell_value )
                                {
                                    cell_comparison = 1;
                                }

                                if ( order_is_descending )
                                {
                                    cell_comparison = -cell_comparison;
                                }

                                return cell_comparison;
                            }
                            );
                    }

                    this.OrderIsDescending = !this.OrderIsDescending;
                    var order_is_descending = this.OrderIsDescending;
                    var sortable_table = $( this ).parents( ".sortable-table" ).eq( 0 );
                    var sortable_column_array = sortable_table.find( ".sortable-column" );
                    var sorted_column = this;

                    sortable_column_array.each(
                        function ( index )
                        {
                            $( this ).removeClass( "order-is-ascending" ).removeClass( "order-is-descending" );

                            if ( this === sorted_column )
                            {
                                if ( order_is_descending )
                                {
                                    $( this ).addClass( "order-is-descending" );
                                }
                                else
                                {
                                    $( this ).addClass( "order-is-ascending" );
                                }
                            }
                        }
                        );

                    var row_array = sortable_table.find( "tr:gt(0)" ).toArray();
                    var sorted_row_array = row_array.sort( GetCellComparison( $( this ).index(), order_is_descending ) );

                    for ( var sorted_row_index = 0;
                          sorted_row_index < sorted_row_array.length;
                          ++sorted_row_index )
                    {
                        sortable_table.append( sorted_row_array[ sorted_row_index ] );
                    }
                }
                );
            }
        );
</script>
