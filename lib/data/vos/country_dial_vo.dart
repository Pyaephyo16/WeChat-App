class CountryDialVO {

  String? name;
  String? dial;
  String? code;
  
  CountryDialVO({
    this.name,
    this.dial,
    this.code,
  });


  @override
  String toString() => 'CountryDialVO(name: $name, dial: $dial, code: $code)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is CountryDialVO &&
      other.name == name &&
      other.dial == dial &&
      other.code == code;
  }

  @override
  int get hashCode => name.hashCode ^ dial.hashCode ^ code.hashCode;
}
