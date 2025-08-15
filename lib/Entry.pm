use     Object::Pad v0.820;

class   Entry 1.00;

use     Management::Boilerplate::Code;

field   $start_time     :param  :reader;
field   $end_time       :param  :reader;
field   $start_year     :param;
field   $start_month    :param;
field   $start_day      :param;
field   $start_epoch;
field   $end_epoch;
field   $category       :param  :accessor;
field   $category2                          =   undef;
field   $details        :param  :accessor;
field   $duration               :accessor   =   0;

method save_data {

    my  $save_data = [
        entries =>  {
            'start_time_utc_epoch'  =>  $start_epoch,
            'end_time_utc_epoch'    =>  $end_epoch,
            'top_category_id'       =>  1, #retrieve a top category id?.
            'details'               =>  $details,
        },
        categories  =>  {
            name                    =>  $category,
            level                   =>  1,
        },
        
        cateories   =>  {
            name                    =>  $category2,
            level                   =>  2,
        },
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

