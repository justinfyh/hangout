class Event {
  final String name;
  final String location;
  final String dateTime;
  final String details;
  final String ownerUid;
  final String imageUrl;
  final String eventId;
  final List<dynamic> going;
  final List<dynamic> interested;

  Event(
      {required this.name,
      required this.location,
      required this.dateTime,
      required this.details,
      required this.ownerUid,
      required this.imageUrl,
      required this.eventId,
      required this.going,
      required this.interested});
}
