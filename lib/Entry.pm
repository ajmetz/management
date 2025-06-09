use     Object::Pad v0.820;

class   Entry 1.00;

use     Management::Boilerplate::Code;

field   $start_time;
field   $end_time;
field   $start_epoch;
field   $end_epoch;
field   $category1;
field   $category2;
field   $detail;
field   $duration;

__END__

Value ideas:
start time
end time
category1 # default misc
category2 # default action
detail
duration
(calculated: totals)