use     Object::Pad v0.820;

class   Management::App::MVC::Model::BusinessLogic::Entry 2.00;

use     Management::App::Boilerplate::Code;
use     Management::App::MVC::View::Language;
use     DateTime;
use     DateTime::Duration;
use     DateTime::Format::Duration;
use     Time::Piece;

=encoding utf8

stuff

=cut

#bob
field   $start          :param  :reader     =   undef;
field   $end            :param  :reader     =   undef;

field   $start_year     :param  :reader     =   undef;
field   $start_month    :param  :reader     =   undef;
field   $start_day      :param  :reader     =   undef;
field   $start_time     :param  :reader     =   undef;

field   $end_year       :param  :reader     =   undef;
field   $end_month      :param  :reader     =   undef;
field   $end_day        :param  :reader     =   undef;
field   $end_time       :param  :reader     =   undef;

field   $start_utc_epoch        :reader     =   undef;
field   $end_utc_epoch          :reader     =   undef;

field   $categories     :param  :accessor   //= ['Misc'];   # TODO: Add validation to the accessor/setter.
                                                            # UPDATE: Validation can be done before saving. 
                                                            # LEVELS: Can tell number of levels by number of items in arrayref.

field   $top_category   :param  :accessor   //= 'OTHER';    # Can be calculated by database look up during save to database via Model/Entry.pm
field   $details        :param  :accessor;                  # Later we could code a subroutine to pick a specific index number that serves as the default.
field   $duration               :reader     =   undef;      # Undef is a clear indication it has not been set / adjust block has failed to calculate one.
field   $duration_data          :reader     =   undef;      # Undef is a clear indication it has not been set / adjust block has failed to calculate one.
field   $logger         :param  :reader;
field   $id             :param  :accessor   =   undef;
field   $language       :param  :accessor   =   Management::App::MVC::View::Language->try_or_die;
field   $time_zone      :param  :reader     //= 'Europe/London';

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

field   $matches_and_captures_utc_epoch     =   qr/
                                                    ^                                     # Start of string
                                                    (?<utc_epoch>\p{Digit}+)              # UTC Epoch - one or more consecutive digits
                                                    $                                     # End of string.
                                                /x;


method $date_time_is_possible_from_params {
    return  $start_day
            && $start_month
            && $start_year
            && $start_time
            && $end_time;
}

method $utc_epoch_to_time_zone_string ($utc_epoch) {

    my  $log        =   $logger->clone( prefix => 'Management::App::MVC::Model::BusinessLogic::Entry::$utc_epoch_to_time_zone_string', );

    my  $datetime   =   DateTime->from_epoch($utc_epoch);
    
    $log->debug('UTC Epoch translated to Datetime: [_1]', $datetime->stringify);
     
    $datetime->set_time_zone($time_zone);
    
    $log->debug('UTC Datetime converted to [_2] Timezone : [_1]', $datetime->stringify, $time_zone);
    $log->debug(
        $datetime->is_dst?  'Daylight saving is in effect.':
        'Daylight saving is not in effect.',
    );
    
    my  $string     =   sprintf("%s %02d:%02d", $datetime->dmy('/'), $datetime->hour, $datetime->minute);

    $log->debug('About to return the following string: [_1]', $string);

    return $string;

}

method $set_year_month_day_time {

        # Initial Values:

        my  $log                =   $logger->clone( prefix => 'Management::App::MVC::Model::BusinessLogic::Entry::$set_year_month_day_time', );

        $log->trace('About to begin processing the start input param, to ensure it delivers the string we want.');

        $start                  =   $start && ($start  =~  $matches_and_captures_utc_epoch)?    $self->$utc_epoch_to_time_zone_string($LAST_PAREN_MATCH):
                                    $start?                                                     $start:
                                    $date_time_is_possible_from_params?                         sprintf(
                                                                                                    '%s/%s/%s %s',
                                                                                                    $start_day,
                                                                                                    $start_month,
                                                                                                    $start_year,
                                                                                                    $start_time
                                                                                                ):
                                    undef;

        $log->trace('About to begin processing the end input param, to ensure it delivers the string we want.');
                    
        $end                    =   $end && ($end    =~  $matches_and_captures_utc_epoch)?      $self->$utc_epoch_to_time_zone_string($LAST_PAREN_MATCH):
                                    $end?                                                       $end:
                                    $date_time_is_possible_from_params?                         sprintf(
                                                                                                    '%s/%s/%s %s',
                                                                                                    $end_day // $start_day,
                                                                                                    $end_month // $start_month,
                                                                                                    $end_year // $start_year,
                                                                                                    $end_time
                                                                                                ):
                                    undef;

        $log->debug('Start is...', { dumping_value => $start });
        $log->debug('End is...', { dumping_value => $end });

        # Definitions:

        $log->trace('About to check our start and end strings for valid start and end values.');

        my  $valid_start_values =   $start  =~  $matches_and_captures_date_and_time?    {%LAST_PAREN_MATCH}:
                                    undef;

        my  $valid_end_values   =   $end    =~  $matches_and_captures_date_and_time?    {%LAST_PAREN_MATCH}:
                                    $end    =~  $matches_and_captures_time?             {%LAST_PAREN_MATCH}:
                                    undef;

        # Premature Exit:

        $log->trace('About to throw an exception if the hashrefs for valid start and end values are undefined, false, or zero length in scalar context.');

        die                         $log->fatal('object.entry.error.invalid_start_values')
                                    unless $valid_start_values;
                                    
        die                         $log->fatal('object.entry.error.invalid_end_values')
                                    unless $valid_end_values;


        # Processing:

        $log->trace('About to set our start year, month, day, and time, from our valid start values.');

        $start_year             =   $valid_start_values->{year};
        $start_month            =   $valid_start_values->{month};
        $start_day              =   $valid_start_values->{day};
        $start_time             =   $valid_start_values->{time};

        $log->trace('About to set our end year, month, day, and time, from our valid end values.');

        $end_year               =   $valid_end_values->{year} // $start_year;
        $end_month              =   $valid_end_values->{month} // $start_month;
        $end_day                =   $valid_end_values->{day} // $start_day;
        $end_time               =   $valid_end_values->{time};

        $log->trace('About to update our end string, using the new values.');

        $log->debug('Before update:', { end => $end });

        $end                    =   $end_day.'/'.$end_month.'/'.$end_year.' '.$end_time;

        $log->debug('After update:', { end => $end });

        $log->debug(
            'Values set as follows: [_1]',
            $language->localise(
                'entry.set_year_month_day_time.log_string_of_set_values',
                ($start_year, $start_month, $start_day, $start_time, $end_year, $end_month, $end_day, $end_time, $end),
            ),
        );


        # Output:

        $log->trace('About to return self for fluent interface / method chaining, and exit method.');

        return $self;

}

method $set_utc_epochs {

    my  $log    =   $logger->clone( prefix => 'Management::App::MVC::Model::BusinessLogic::Entry::$set_utc_epochs', );

    # Premature exit if already set - this presumably needs more validation:

    $log->debug('UTC epochs already set.') if $start_utc_epoch && $end_utc_epoch;

    return $self if $start_utc_epoch && $end_utc_epoch;

    my  $start_datetime =   DateTime->new(

                                year        =>  $start_year,
                                month       =>  $start_month,
                                day         =>  $start_day,
    
                                hour        =>  0+Time::Piece->strptime($start_time, '%H:%M')->strftime('%H'),
                                minute      =>  0+Time::Piece->strptime($start_time, '%H:%M')->strftime('%M'),
                                time_zone   =>  $time_zone,
    
                            );

    $log->debug('Start Datetime created in "[_2]" timezone: [_1]', $start_datetime->stringify, $time_zone);
    $log->debug(
        $start_datetime->is_dst?  'Daylight saving is in effect.':
        'Daylight saving is not in effect.',
    );

    $start_datetime->set_time_zone('UTC');

    $log->debug('Start Datetime converted to UTC timezone: [_1]', $start_datetime->stringify);
    $log->debug(
        $start_datetime->is_dst?  'Daylight saving is in effect.':
        'Daylight saving is not in effect.',
    );

    $start_utc_epoch    =   $start_datetime->epoch;

    my $end_datetime    =   DateTime->new(

                                # Assume same year/month/day as start time, unless end year/month/day given:
                                year        =>  $end_year,
                                month       =>  $end_month,
                                day         =>  $end_day,

                                hour        =>  0+Time::Piece->strptime($end_time, '%H:%M')->strftime('%H'),
                                minute      =>  0+Time::Piece->strptime($end_time, '%H:%M')->strftime('%M'),
                                time_zone   =>  $time_zone,

                            );

    $log->debug('End Datetime created in "[_2]" timezone: [_1]', $end_datetime->stringify, $time_zone);
    $log->debug(
        $end_datetime->is_dst?  'Daylight saving is in effect.':
        'Daylight saving is not in effect.',
    );

    $end_datetime->set_time_zone('UTC');

    $log->debug('End Datetime converted to UTC timezone: [_1]', $end_datetime->stringify);
    $log->debug(
        $end_datetime->is_dst?  'Daylight saving is in effect.':
        'Daylight saving is not in effect.',
    );                            

    $end_utc_epoch      =   $end_datetime->epoch;

    $log->debug('UTC epochs set.', { start_utc_epoch => $start_utc_epoch, end_utc_epoch => $end_utc_epoch });

    return $self;

}

method $set_duration_data {

    my  $log    =   $logger->clone( prefix => 'Management::App::MVC::Model::BusinessLogic::Entry::$set_duration_data', );

    my  $delimiter  =   '|';

    $duration_data  =   [
                            split(
                                quotemeta($delimiter),
                                DateTime::Format::Duration->new(
                                    normalise   =>  1, # While normalise will give us hours and minutes where we previously had only seconds - will 24 hours show as zero hours and 1 day? Worth testing.
                                    pattern     =>  '%H'.$delimiter.'%M',
                                )
                                ->format_duration(
                                    DateTime->from_epoch($end_utc_epoch)
                                    ->subtract_datetime_absolute(
                                        DateTime->from_epoch($start_utc_epoch)
                                    )
                                )
                            )
                        ];

    $log->debug('Set duration data.', {duration_data => $duration_data}, );

    return $self;

}

method $set_duration {

    my  $log    =   $logger->clone( prefix => 'Management::App::MVC::Model::BusinessLogic::Entry::$set_duration', );

    $log->debug('End UTC Epoch is [_1] and Start UTC Epoch is [_2].', $end_utc_epoch, $start_utc_epoch);

    $self->$set_duration_data;
    
    $duration       =   $language->localise(
                            'model.entry.set_duration.duration_string', # i.e. 1hr 30mins
                            $duration_data->@*,
                        );

    $log->debug('Duration is...', { duration => $duration }, );

    return $self;

}

method $instance_setup {

    my  $log    =   $logger->clone( prefix => 'Management::App::MVC::Model::BusinessLogic::Entry::$instance_setup', );

    $log->trace('About to set the order in which we will run our setup-related private methods.');

    $self
    ->$set_year_month_day_time
    ->$set_utc_epochs
    ->$set_duration;

}

method status_string {
    return $language->localise(
        'object.entry.status.formatting',
        $self->status_array(
            $language->localise('object.entry.status.category_delimiter')
        ),
    );
}

method status_log_string {
    return $language->localise(
        'object.entry.status.log_formatting',
        $self->status_array(
            $language->localise('object.entry.status.category_log_delimiter')
        ),
    );
}

# An array means a predictable order.
method status_array ($category_delimiter //= $language->localise('object.entry.status.category_delimiter') ) {
    return (
        __CLASS__,
        $self->id,
        $self->time_zone,
        $self->start,
        $self->end,
        $self->start_utc_epoch,
        $self->end_utc_epoch,
        $self->duration,
        $self->top_category,
        join(
            $category_delimiter,
            $self->categories->@*
        ),
        $self->details,
    );
}



ADJUST {

    my  $log    =   $logger->clone( prefix => 'Management::App::MVC::Model::BusinessLogic::Entry::new - ADJUST Phase', );

    $log->trace(
        'About to call private method [_1] as part of new\'s ADJUST phase (See URL: [_2]).', # Phrase
        '$instance_setup', # Private Method Name
        'https://metacpan.org/pod/Object::Pad#The-ADJUST-phase', # URL
    );

    $self->$instance_setup;
 
    $log->debug('Instance status is: ', { status_log_string => $self->status_log_string });
}



__END__
