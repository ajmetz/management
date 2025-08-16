use     Object::Pad v0.820;

class   Entry 1.00;

use     Management::Boilerplate::Code;
use     DateTime;
use     DateTime::Duration;
use     Time::Piece;

field   $start_time     :param  :reader;
field   $end_time       :param  :reader;

field   $start_year     :param  :reader;
field   $start_month    :param  :reader;
field   $start_day      :param  :reader;

field   $end_year       :param  :reader;
field   $end_month      :param  :reader;
field   $end_day        :param  :reader;

field   $start_epoch    :param  :accessor   =   undef; # We'll need ellaborated accessor methods to provide validation at some stage, or at least a dedicated epoch validation method.
field   $end_epoch      :param  :accessor   =   undef;

field   $categories     :param  :accessor   =   [{'Misc',1}];
field   $top_category   :param  :accessor;
field   $details        :param  :accessor;  # Later we could code a subroutine to pick a specific index number that serves as the default.
field   $duration               :reader     =   undef; # Undef is a clear indication it has not been set / adjust block has failed to calculate one.

method $create_epochs {

    $start_epoch    =           DateTime->new(
                                    year    =>  $start_year,
                                    month   =>  $start_month,
                                    day     =>  $start_day,
                                    hour    =>  0+Time::Piece->strptime($start_time, '%H:%M')->strftime('%H'),
                                    minute  =>  0+Time::Piece->strptime($start_time, '%H:%M')->strftime('%M'),
                                )->epoch;

    $end_epoch      =           DateTime->new(
                                    year    =>  $end_year // $start_year,
                                    month   =>  $end_month // $start_month,
                                    day     =>  $end_day // $start_day,
                                    hour    =>  0+Time::Piece->strptime($end_time, '%H:%M')->strftime('%H'),
                                    minute  =>  0+Time::Piece->strptime($end_time, '%H:%M')->strftime('%M'),
                                )->epoch;
    return $self;
}

method $create_duration {
    $duration       =   sprintf(
                            '%dhr %dmins', # i.e. 1hr 30mins
                            DateTime->from_epoch($end_epoch)
                            ->subtract_datetime_absolute(
                                DateTime->from_epoch($start_epoch)
                            )
                            ->in_units('hours','minutes'),
                        ); # This should be localised at some point?

    #DateTime->from_epoch($end_epoch) - DateTime->from_epoch($end_epoch)
}

ADJUST {
    
    $self->$create_epochs->$create_duration;
    
    #$self->valid_epochs_or_die(@created_epochs);
 
}

method save_data {

    my  $save_data = [
        entries         =>  {
                                'start_time_utc_epoch'  =>  $start_epoch,
                                'end_time_utc_epoch'    =>  $end_epoch,
                                #'top_category_id'       =>  1, #retrieve a top category id?. UPDATE: NO. Commented out. Database retrieval happens in the model folder, not in the object class.
                                'top_category'          =>  $top_category,
                                'details'               =>  $details,
                            },
        categories      =>  $categories,
        top_categories  =>  {
                                name                    =>  'Other',
                            }
    ];

}



__END__

Value ideas:
start time
end time
category1 # default misc
category2 # default action
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