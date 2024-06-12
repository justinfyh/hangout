class Event {
  final String name;
  final String location;
  final String dateTime;
  final String details;
  final String ownerUid;
  final String imageUrl;

  Event(
      {required this.name,
      required this.location,
      required this.dateTime,
      required this.details,
      required this.ownerUid,
      required this.imageUrl});
}
