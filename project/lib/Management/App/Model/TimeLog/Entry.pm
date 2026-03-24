use     Object::Pad v0.820;

class   Management::App::Model::TimeLog::Entry 2.00;

use     Management::App::Boilerplate::Code;
use     DateTime;
use     DateTime::Duration;
use     Time::Piece;

#bob
field   $start          :param              =   undef;
field   $end            :param              =   undef;

field   $start_year             :reader     =   undef;
field   $start_month            :reader     =   undef;
field   $start_day              :reader     =   undef;
field   $start_time             :reader     =   undef;

field   $end_year               :reader     =   undef;
field   $end_month              :reader     =   undef;
field   $end_day                :reader     =   undef;
field   $end_time               :reader     =   undef;

field   $start_epoch            :reader     =   undef;
field   $end_epoch              :reader     =   undef;

field   $categories     :param  :accessor   =   ['Misc'];   # TODO: Add validation to the accessor/setter.
                                                            # UPDATE: Validation can be done before saving. 
                                                            # LEVELS: Can tell number of levels by number of items in arrayref.

field   $top_category   :param  :accessor   =   undef;      # Can be calculated by database look up during save to database via Model/Entry.pm
field   $details        :param  :accessor;                  # Later we could code a subroutine to pick a specific index number that serves as the default.
field   $duration               :reader     =   undef;      # Undef is a clear indication it has not been set / adjust block has failed to calculate one.
field   $app            :param;
field   $id                     :accessor   =   undef;

field   $matches_and_captures_date_and_time =   qr/
                                                    ^                                     # Start of string
                                                    (?<day>\p{Digit}{2})                  # Day - two consecutive digits
                                                    \/                                    # Slash
                                                    (?<month>\p{Digit}{2})                # Month - two consecutive digits
                                                    \/                                    # Slash
                                                    (?<year>\p{Digit}{4})                 # Year - four consecutive digits
                                                    \s+                                   # One or more characters that are spaces
                                                    (?<time>\p{Digit}{2}:\p{Digit}{2})    # Time - two digits, colon, two digits
                                                    $                                     # End of string.
                                                /x;

field   $matches_and_captures_time          =   qr/
                                                    ^                                     # Start of string
                                                    (?<time>\p{Digit}{2}:\p{Digit}{2})    # Time - two digits, colon, two digits
                                                    $                                     # End of string.
                                                /x;

field   $matches_and_captures_epoch         =   qr/
                                                    ^                                     # Start of string
                                                    (?<epoch>\p{Digit}+)                  # Epoch - one or more consecutive digits
                                                    $                                     # End of string.
                                                /x;



method $epoch_to_string ($epoch) {

    my  $datetime   =   DateTime->from_epoch($epoch);
    my  $string     =   sprintf("%s %02d:%02d", $datetime->dmy('/'), $datetime->hour, $datetime->minute);

    return $self;

}

method $set_year_month_day_time {


        # Initial Values:        
        $start  =   $self->$epoch_to_string(%LAST_PAREN_MATCH{epoch})
                    if ($start  =~  $matches_and_captures_epoch);
                    
        $end    =   $self->$epoch_to_string(%LAST_PAREN_MATCH{epoch})
                    if ($end    =~  $matches_and_captures_epoch);

        # Definitions:
        my  $valid_start_values =   $start  =~  $matches_and_captures_date_and_time?    {%LAST_PAREN_MATCH}:
                                    undef;

        my  $valid_end_values   =   $end    =~  $matches_and_captures_date_and_time?    {%LAST_PAREN_MATCH}:
                                    $end    =~  $matches_and_captures_time?             {%LAST_PAREN_MATCH}:
                                    undef;

        # Premature Exit:
        die $app->log_fatal('object.entry.error.invalid_start_values'   ) unless $valid_start_values;
        die $app->log_fatal('object.entry.error.invalid_end_values'     ) unless $valid_end_values;

        # Processing:
        $start_year             =   $valid_start_values->{year};
        $start_month            =   $valid_start_values->{month};
        $start_day              =   $valid_start_values->{day};
        $start_time             =   $valid_start_values->{time};
    
        $end_year               =   $valid_end_values->{year};
        $end_month              =   $valid_end_values->{month};
        $end_day                =   $valid_end_values->{day};
        $end_time               =   $valid_end_values->{time};

        # Output:
        return $self;                
      
}

method $set_epochs {

    # Premature exit if already set - this presumably needs more validation:
    return $self if $start_epoch && $end_epoch;
    
    $start_epoch    =   DateTime->new(

                            year    =>  $start_year,
                            month   =>  $start_month,
                            day     =>  $start_day,

                            hour    =>  0+Time::Piece->strptime($start_time, '%H:%M')->strftime('%H'),
                            minute  =>  0+Time::Piece->strptime($start_time, '%H:%M')->strftime('%M'),

                        )->epoch;

    $end_epoch      =   DateTime->new(

                            # Assume same year/month/day as start time, unless end year/month/day given:
                            year    =>  $end_year // $start_year,
                            month   =>  $end_month // $start_month,
                            day     =>  $end_day // $start_day,

                            hour    =>  0+Time::Piece->strptime($end_time, '%H:%M')->strftime('%H'),
                            minute  =>  0+Time::Piece->strptime($end_time, '%H:%M')->strftime('%M'),

                        )->epoch;

    return $self;

}

method $set_duration {

    $duration       =   sprintf(
                            '%dhr %dmins', # i.e. 1hr 30mins
                            DateTime
                                ->from_epoch($end_epoch)
                                ->subtract_datetime_absolute(
                                    DateTime->from_epoch($start_epoch)
                                )
                                ->in_units('hours','minutes')
                            ,
                        ); # This should be localised at some point?

    return $self;

}

method $instance_setup {

    $self
    #->$set_logger
    ->$set_year_month_day_time
    ->$set_epochs
    ->$set_duration;

}

ADJUST {
    
    $self->$instance_setup;
    
    #$self->valid_epochs_or_die(@created_epochs);
 
}



__END__

Value ideas:
start time
end time
category1 # default misc
category2 # default action <--- What's this? Are category1 and category2 independent, 
                                as in one entry spanning two categories (repeating?).
                                In the latest version we prefer to have an entry only appearing in one category,
                                but that category can be under other categories as a subcategory.
                                This determined at the Perl level by what categories are listed in categories,
                                with the top category determined by the top category database association with
                                the final child category for this specific entry.
detail
duration
(calculated: totals)

Old save_data return:
    return {
        entries               =>  {
                                    start_time_utc_epoch    =>  '???',
                                     # Okay - to calculate the epoch, we need to know the day, we cannot just use the start time without a day. So our input must include a day.
                                },
        categories            =>  {
                                },
        'entries_categories'    =>  {
                                },
    };

======

Right! We need to rethink how we're doing categories:

Why not just a list?

@categories = ({name, level}, {name, level}, {etc, etc});
or
$categories = [{name, level}, {name, level}, {etc, etc}];

So what happens at the constructor level?
You can construct with categories - expecting an array ref containing a hashref.
Or you could simply use an add_category setter,
There'd also need to be a remove category method.
You'd probably need a list_categories method too, for the adding and removing to be useful.
For now, let's keep it simple with simply $categories/@categories,
as an accessor and constructor param.

As regards validation - we should have dedicated validation methods that are common,
and thus can be called from methods, called from construction, or called from outside.

======

What's involved in creating and populating the epochs?

    Is input valid?
        If so, make an epoch from it.
        Is the resultant epoch valid?
        If so, make
        
        
=======

Removed save data:

method save_data {

    return {
        entries         =>  [{
                                'start_time_utc_epoch'  =>  $start_epoch,
                                'end_time_utc_epoch'    =>  $end_epoch,
                                #'top_category_id'       =>  1, #retrieve a top category id?. UPDATE: NO. Commented out. Database retrieval happens in the model folder, not in the object class.
                                'top_category_id'          =>  $top_category,
                                'details'               =>  $details,
                            }],
        categories      =>  $categories,
        top_categories  =>  [{
                                top_category            =>  'Other',
                            }],
    };

}