use     Object::Pad v0.820;

class   Management::App::Model::TimeLog::Entry 2.00;

use     Management::App::Boilerplate::Code;
use     DateTime;
use     DateTime::Duration;
use     DateTime::Format::Duration;
use     Time::Piece;

#bob
field   $start          :param  :reader     =   undef;
field   $end            :param  :reader     =   undef;

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
field   $duration_data          :reader     =   undef;      # Undef is a clear indication it has not been set / adjust block has failed to calculate one.
field   $logger         :param;
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

    return $string;

}

method $set_year_month_day_time {


        # Initial Values:
#        warn 'Dumping values.';
#        $logger->dump_values($LAST_PAREN_MATCH) if ($start =~ $matches_and_captures_epoch);
        
        $start  =  $self->$epoch_to_string($LAST_PAREN_MATCH)
                    if ($start  =~  $matches_and_captures_epoch);
                    
        $end    =   $self->$epoch_to_string($LAST_PAREN_MATCH)
                    if ($end    =~  $matches_and_captures_epoch);

        # Definitions:
        my  $valid_start_values =   $start  =~  $matches_and_captures_date_and_time?    {%LAST_PAREN_MATCH}:
                                    undef;

        my  $valid_end_values   =   $end    =~  $matches_and_captures_date_and_time?    {%LAST_PAREN_MATCH}:
                                    $end    =~  $matches_and_captures_time?             {%LAST_PAREN_MATCH}:
                                    undef;
        #warn 'What?';
        #$logger->dump_values($start);

        # Premature Exit:
        die $logger->fatal('object.entry.error.invalid_start_values'   ) unless $valid_start_values;
        die $logger->fatal('object.entry.error.invalid_end_values'     ) unless $valid_end_values;

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

method $set_duration_data {

    my  $delimiter  =   '|';

    $duration_data  =   [
                            split(
                                quotemeta($delimiter),
                                DateTime::Format::Duration->new(
                                    normalise   =>  1, # While normalise will give us hours and minutes where we previously had only seconds - will 24 hours show as zero hours and 1 day? Worth testing.
                                    pattern     =>  '%H'.$delimiter.'%M',
                                )
                                ->format_duration(
                                    DateTime->from_epoch($end_epoch)
                                    ->subtract_datetime_absolute(
                                        DateTime->from_epoch($start_epoch)
                                    )
                                )
                            )
                        ];

    return $self;

}

method $set_duration {

    my  $log    =   $logger->context('[Management::App::Model::TimeLog::Entry::$set_duration]');

    $log->debug('End Epoch is [_1] and Start Epoch is [_2].',$end_epoch,$start_epoch);

    $self->$set_duration_data;
    $log->trace('Set duration data.')->dump_values($duration_data);
    
    $duration       =   $log->language->localise(
                            'model.entry.set_duration.duration_string', # i.e. 1hr 30mins
                            $duration_data->@*,
                        );

    $log->debug('Duration is...')->dump_values($duration);

    return $self;

}

method $instance_setup {

    $self
    #->$set_logger
    ->$set_year_month_day_time
    ->$set_epochs
    ->$set_duration;

}

method status_string {
    return $logger->language->localise(
        'object.entry.status.formatting',
        $self->status_array,
    );
}

# An array means a predictable order.
method status_array {
    return (
        __CLASS__,
        $self->id,
        $self->start,
        $self->end,
        $self->start_epoch,
        $self->end_epoch,
        $self->duration,
        $self->top_category,
        join(
            $logger->language->localise('object.entry.status.category_delimiter'),
            $self->categories->@*
        ),
        $self->details,
    );
}

ADJUST {
    
    $self->$instance_setup;
    
    #$self->valid_epochs_or_die(@created_epochs);
 
}



__END__
