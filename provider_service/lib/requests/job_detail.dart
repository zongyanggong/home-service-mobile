import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:user/service/appbar_titles.dart';
import 'package:user/services/info_state.dart';
import 'package:user/services/record_status.dart';
import 'package:user/services/service_record.dart';
import 'package:user/share/appBarTitle.dart';
import 'package:user/share/job_status.dart';
import 'package:user/share/label_field.dart';
import 'package:provider/provider.dart';

class JobDetail extends StatefulWidget {
  JobDetail({super.key, required this.serviceRecord});
  TempServiceRecord serviceRecord;

  @override
  State<JobDetail> createState() => _JobDetailState();
}

class _JobDetailState extends State<JobDetail> {
  @override
  Widget build(BuildContext context) {
    // var info = Provider.of<Info>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: AppBarTitle(title: "Job Detail"),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage(widget.serviceRecord.imgPath),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.only(left: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.serviceRecord.name,
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Row(
                            children: [
                              Expanded(
                                  child: LabelField(
                                      title: "Job",
                                      hint: categories[
                                          widget.serviceRecord.sid])),
                              Expanded(
                                  child: LabelField(
                                      title: "Job fees",
                                      hint:
                                          "CAD \$ ${widget.serviceRecord.price} /hour")),
                            ],
                          ),
                          LabelField(
                            title: "Booking for",
                            hint:
                                "${DateFormat.yMd().format(DateTime.fromMillisecondsSinceEpoch(widget.serviceRecord.bookingStartTime))} ${format24HourTime(TimeOfDay(hour: DateTime.fromMillisecondsSinceEpoch(widget.serviceRecord.bookingStartTime).hour, minute: DateTime.fromMillisecondsSinceEpoch(widget.serviceRecord.bookingStartTime).minute))}-${format24HourTime(TimeOfDay(hour: DateTime.fromMillisecondsSinceEpoch(widget.serviceRecord.bookingEndTime).hour, minute: DateTime.fromMillisecondsSinceEpoch(widget.serviceRecord.bookingEndTime).minute))}",
                          ),
                          LabelField(
                              title: "Address",
                              hint: widget.serviceRecord.address!),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: widget.serviceRecord.status == RecordStatus.pending
                  ? PendingButton(
                      serviceRecord: widget.serviceRecord,
                      onCancelJob: () {
                        setState(() {
                          widget.serviceRecord.status = RecordStatus.rejected;
                          widget.serviceRecord.actualEndTime = DateTime.now();
                        });
                      },
                      onAcceptJob: () {
                        setState(() {
                          widget.serviceRecord.status = RecordStatus.confirmed;
                          widget.serviceRecord.acceptedTime = DateTime.now();
                        });
                      },
                    )
                  : widget.serviceRecord.status == RecordStatus.confirmed ||
                          widget.serviceRecord.status == RecordStatus.started
                      ? JobDetailButton(serviceRecord: widget.serviceRecord,onButtonClick: (){
                        if (widget.serviceRecord.status==RecordStatus.confirmed){
                          setState(() {
                            widget.serviceRecord.status=RecordStatus.started;
                            debugPrint("click1");
                            debugPrint(widget.serviceRecord.status.toString());
                            widget.serviceRecord.actualStartTime=DateTime.now();
                          });
                        }else if (widget.serviceRecord.status==RecordStatus.started){
                          setState(() {
                            widget.serviceRecord.status=RecordStatus.completed;
                            widget.serviceRecord.actualEndTime=DateTime.now();
                          });
                        }else{

                        }
              },)
                      : null,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Job Status",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[600])),
                  JobStatus(
                    title: "Job Pending",
                    subTitle: widget.serviceRecord.createTime != null
                        ? "Job created on ${DateFormat.yMd().format(widget.serviceRecord.createTime)} ${format24HourTime(TimeOfDay(hour: widget.serviceRecord.createTime.hour, minute: widget.serviceRecord.createTime.minute))}"
                        : "",
                    active: widget.serviceRecord.status == RecordStatus.pending,
                  ),
                  if (widget.serviceRecord.status ==
                      RecordStatus.rejected) //job rejected by provider
                    JobStatus(
                      title: "Job Rejected",
                      subTitle: widget.serviceRecord.actualEndTime != null
                          ? "Job rejected on ${DateFormat.yMd().format(widget.serviceRecord.actualEndTime!)} ${format24HourTime(TimeOfDay(hour: widget.serviceRecord.actualEndTime!.hour, minute: widget.serviceRecord.actualEndTime!.minute))}"
                          : "",
                      active:
                          widget.serviceRecord.status == RecordStatus.rejected,
                    ),
                  if (widget.serviceRecord.status ==
                      RecordStatus.canceled) //job canceled by user
                    JobStatus(
                      title: "Job Canceled",
                      subTitle: widget.serviceRecord.actualEndTime != null
                          ? "Job canceled on ${DateFormat.yMd().format(widget.serviceRecord.actualEndTime!)} ${format24HourTime(TimeOfDay(hour: widget.serviceRecord.actualEndTime!.hour, minute: widget.serviceRecord.actualEndTime!.minute))}"
                          : "",
                      active:
                          widget.serviceRecord.status == RecordStatus.canceled,
                    ),
                  if (widget.serviceRecord.status != RecordStatus.canceled &&
                      widget.serviceRecord.status != RecordStatus.rejected)
                    JobStatus(
                      title: "Job Accepted",
                      subTitle: widget.serviceRecord.acceptedTime != null
                          ? "Job accepted on ${DateFormat.yMd().format(widget.serviceRecord.acceptedTime!)} ${format24HourTime(TimeOfDay(hour: widget.serviceRecord.acceptedTime!.hour, minute: widget.serviceRecord.acceptedTime!.minute))}"
                          : "",
                      active:
                          widget.serviceRecord.status == RecordStatus.confirmed,
                    ),
                  if (widget.serviceRecord.status != RecordStatus.canceled &&
                      widget.serviceRecord.status != RecordStatus.rejected)
                    JobStatus(
                      title: "Job In Process",
                      subTitle: widget.serviceRecord.actualStartTime != null
                          ? "Job started on ${DateFormat.yMd().format(widget.serviceRecord.actualStartTime!)} ${format24HourTime(TimeOfDay(hour: widget.serviceRecord.actualStartTime!.hour, minute: widget.serviceRecord.actualStartTime!.minute))}"
                          : "",
                      active:
                          widget.serviceRecord.status == RecordStatus.started,
                    ),
                  if (widget.serviceRecord.status != RecordStatus.canceled &&
                      widget.serviceRecord.status != RecordStatus.rejected)
                    JobStatus(
                      title: "Job Completed",
                      subTitle: widget.serviceRecord.actualEndTime != null
                          ? "Job started on ${DateFormat.yMd().format(widget.serviceRecord.actualEndTime!)} ${format24HourTime(TimeOfDay(hour: widget.serviceRecord.actualEndTime!.hour, minute: widget.serviceRecord.actualEndTime!.minute))}"
                          : "",
                      active:
                          widget.serviceRecord.status == RecordStatus.completed,
                    ),
                ],
              ),
            ),
            if (widget.serviceRecord.score != null &&
                widget.serviceRecord.status == RecordStatus.completed)
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Rating",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[600])),
                    Padding(
                      padding: const EdgeInsets.only(left: 18, top: 9),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(right: 5),
                            child: Text(
                              widget.serviceRecord.score!.toStringAsFixed(2),
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.normal),
                            ),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              for (int i = 0;
                                  i < widget.serviceRecord.score!.floor();
                                  i++)
                                const Icon(
                                  Icons.star,
                                  color: Colors.green,
                                  size: 15,
                                ),
                              for (int i = widget.serviceRecord.score!.floor();
                                  i < 5;
                                  i++)
                                const Icon(
                                  Icons.star_border,
                                  color: Colors.green,
                                  size: 15,
                                ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            if (widget.serviceRecord.review != null &&
                widget.serviceRecord.status == RecordStatus.completed)
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Review",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[600])),
                    Padding(
                      padding: const EdgeInsets.only(left: 18, top: 9),
                      child: Text(widget.serviceRecord.review!),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class JobDetailButton extends StatelessWidget {
  JobDetailButton({super.key, required this.serviceRecord, this.onButtonClick});

  TempServiceRecord serviceRecord;
  final VoidCallback? onButtonClick;

  @override
  Widget build(BuildContext context) {
    debugPrint(serviceRecord.status.toString());
    return ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
        ),
        onPressed: onButtonClick ?? () {},
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(serviceRecord.status == RecordStatus.confirmed
                ? Icons.build
                : serviceRecord.status == RecordStatus.started
                    ? Icons.thumb_up
                    : null),
            const SizedBox(
              width: 10,
            ),
            Text(
                serviceRecord.status == RecordStatus.confirmed
                    ? "Start Job"
                    : serviceRecord.status == RecordStatus.started
                        ? "Mark Job Complete"
                        : "",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                )),
          ],
        ));
  }
}

class PendingButton extends StatelessWidget {
  PendingButton(
      {super.key,
      required this.serviceRecord,
      this.onCancelJob,
      this.onAcceptJob});
  TempServiceRecord serviceRecord;
  final VoidCallback? onCancelJob;
  final VoidCallback? onAcceptJob;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
                ),
                onPressed: onCancelJob ?? () {},
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.close),
                    SizedBox(
                      width: 10,
                    ),
                    Text("Cancel Job"),
                  ],
                ))),
        const SizedBox(
          width: 10,
        ),
        Expanded(
            child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.green),
                ),
                onPressed: onAcceptJob ?? () {},
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.check),
                    SizedBox(
                      width: 10,
                    ),
                    Text("Accept Job"),
                  ],
                ))),
      ],
    );
  }
}
