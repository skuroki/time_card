module ApplicationHelper
  def render_forms_for_attendance(attendance)
    state = attendance&.state || :not_at_work

    case state
    when :not_at_work
      new_attendance = Attendance.new
      render 'attendances/form', attendance: new_attendance
    when :at_work
      rest = attendance.rests.build
      clock_out = attendance.build_clock_out
      render('rests/form', rest:) + render('clock_outs/form', clock_out:)
    when :on_a_break
      rest_finish = attendance.rests.last.build_rest_finish
      render 'rest_finishes/form', rest_finish:
    end
  end
end
