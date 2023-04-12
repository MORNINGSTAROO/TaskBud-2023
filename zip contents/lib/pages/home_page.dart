import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeState();
}

class _HomeState extends State<HomeScreen> {
  final List<Appointment> _appointments = <Appointment>[];
  late AppointmentDataSource dataSource;

  @override
  void initState() {
    super.initState();
    dataSource = getCalendarDataSource();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Container(
        width: 450,
        padding: const EdgeInsets.all(5),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.95,
                  height: MediaQuery.of(context).size.height * 0.45,
                  child: SfCalendar(
                    view: CalendarView.month,
                    dataSource: dataSource,
                    onSelectionChanged: selectionChanged,
                  ),
                ),
              ],
            ),
            const Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 0)),
            Container(
                width: MediaQuery.of(context).size.width * 0.95,
                height: MediaQuery.of(context).size.height * 0.32,
                color: Colors.black12,
                child: ListView.separated(
                  padding: const EdgeInsets.all(2),
                  itemCount: _appointments.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                        padding: const EdgeInsets.all(2),
                        height: 60,
                        color: _appointments[index].color,
                        child: ListTile(
                          leading: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Expanded(
                                child: Text(
                                  _appointments[index].isAllDay
                                      ? ''
                                      : DateFormat('hh:mm a').format(
                                          _appointments[index].startTime),
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                      height: 1.5),
                                ),
                              ),
                              Expanded(
                                  child: Text(
                                _appointments[index].isAllDay ? 'All day' : '',
                                style: const TextStyle(
                                    color: Colors.white,
                                    height: 1.1,
                                    fontWeight: FontWeight.w600),
                              )),
                              Expanded(
                                child: Text(
                                  _appointments[index].isAllDay
                                      ? ''
                                      : DateFormat('hh:mm a')
                                          .format(_appointments[index].endTime),
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                          title: Text(_appointments[index].subject,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white)),
                        ));
                  },
                  separatorBuilder: (BuildContext context, int index) =>
                      const Divider(
                    height: 5,
                  ),
                ))
          ],
        ),
      ),
    ));
  }

  void selectionChanged(CalendarSelectionDetails calendarSelectionDetails) {
    getSelectedDateAppointments(calendarSelectionDetails.date);
  }

  void getSelectedDateAppointments(DateTime? selectedDate) {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
      setState(() {
        _appointments.clear();
      });

      if (dataSource.appointments!.isEmpty) {
        return;
      }

      for (int i = 0; i < dataSource.appointments!.length; i++) {
        Appointment appointment = dataSource.appointments![i] as Appointment;

        /// It return the occurrence appointment for the given pattern
        /// appointment at the selected date.
        final Appointment? occurrenceAppointment =
            dataSource.getOccurrenceAppointment(appointment, selectedDate!, '');
        if ((DateTime(appointment.startTime.year, appointment.startTime.month,
                    appointment.startTime.day) ==
                DateTime(
                    selectedDate.year, selectedDate.month, selectedDate.day)) ||
            occurrenceAppointment != null) {
          setState(() {
            _appointments.add(appointment);
          });
        }
      }
    });
  }
}

AppointmentDataSource getCalendarDataSource() {
  List<Appointment> appointments = <Appointment>[];

  appointments.add(Appointment(
    startTime: DateTime.now(),
    endTime: DateTime.now().add(const Duration(minutes: 10)),
    subject: 'Meeting',
    color: Colors.blue,
    startTimeZone: '',
    endTimeZone: '',
  ));

  appointments.add(Appointment(
      startTime: DateTime.now().add(const Duration(days: -1)),
      endTime: DateTime.now().add(const Duration(hours: 1)),
      subject: 'Recurrence',
      color: Colors.red,
      recurrenceRule: 'FREQ=DAILY;INTERVAL=2;COUNT=10'));

  appointments.add(Appointment(
      startTime: DateTime.now().add(const Duration(hours: 4, days: -1)),
      endTime: DateTime.now().add(const Duration(hours: 5, days: -1)),
      subject: 'Release Meeting',
      color: Colors.lightBlueAccent,
      isAllDay: true));

  appointments.add(Appointment(
    startTime: DateTime.now(),
    endTime: DateTime.now().add(const Duration(hours: 1)),
    subject: 'Meeting',
    color: const Color.fromARGB(200, 140, 230, 1),
  ));

  appointments.add(Appointment(
    startTime: DateTime.now(),
    endTime: DateTime.now().add(const Duration(hours: 2)),
    subject: 'Meeting',
    color: const Color.fromARGB(200, 140, 230, 1),
  ));

  appointments.add(Appointment(
    startTime: DateTime.now(),
    endTime: DateTime.now().add(const Duration(hours: 3)),
    subject: 'Meeting',
    color: const Color.fromARGB(200, 140, 230, 1),
  ));

  appointments.add(Appointment(
    startTime: DateTime.now().add(const Duration(days: -2, hours: 4)),
    endTime: DateTime.now().add(const Duration(days: -2, hours: 5)),
    subject: 'Development Meeting   New York, U.S.A',
    color: const Color.fromARGB(255, 249, 146, 12),
  ));

  return AppointmentDataSource(appointments);
}

class AppointmentDataSource extends CalendarDataSource {
  AppointmentDataSource(List<Appointment> source) {
    appointments = source;
  }
}
