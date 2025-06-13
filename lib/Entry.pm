use     Object::Pad v0.820;

class   Entry 1.00;

use     Management::Boilerplate::Code;

field   $start_time :param :accessor;
field   $end_time   :param :accessor;
field   $start_epoch;
field   $end_epoch;
field   $category  :param :accessor;
field   $category2;
field   $details     :param :accessor;
field   $duration   :accessor =   0;

__END__

Value ideas:
start time
end time
category1 # default misc
category2 # default action
detail
duration
(calculated: totals)