abstract class DataSource<T, S> {
  final S source;

  DataSource(this.source);

  T getData();
}
