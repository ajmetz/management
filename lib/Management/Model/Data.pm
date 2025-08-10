use     Object::Pad v0.820;

class   Management::Model::Data;
use     Management::Boilerplate::Code;
use     Management::Languages;
use     Mojo::Util qw(dumper);
use     English;

field $database :accessor :param;

#ADJUST {
#    die "Database object should be a" $database
#}
# Worry about validation and language / phrase translation implications later.

#method table_list {
#    #$check_database_is_valid;
#    #$database->app->;
#    my $this = $database->dbh->table_info(undef,undef,undef,"'TABLE','VIEW','LOCAL TEMPORARY'");
#    die "Here is our dump:\n".dumper($this);
#    return $this;
#}

method retrieve {
    my  $captures_table_name    =   qr/
                                        ^                   # Start
                                        \"main\"\.\"        # main in speechmarks followed by a dot followed by an opening speechmark
                                        (?<table_name>.+)   # One or more of any characters
                                        \"                 # Followed by a closing speechmark
                                        $                   # End
                                    /x;
    
    #warn dumper $database->tables;
    
    my  @short_table_names      =   map {($ARG =~ $captures_table_name)? $+{'table_name'}:()} $database->tables->@*;
    
    #warn "Short table names:".join("\n", @short_table_names);
    
    
    
    my $data =  {};
    for my $current_table (@short_table_names) {
        $data->{$current_table} = $database->select($current_table)->hashes->to_array;
    };
    
    #warn "Our data:".dumper($data);
    
    #die "That'll do.";
    
    return $data;
}

method save {

}



__END__
