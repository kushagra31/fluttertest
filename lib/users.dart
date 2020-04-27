class users{

  String em;
  String uid;
  int VId;
  String N;
  int EId;
  int PN;
  String G;
  String L;
  String MTS;
  users(this.em,this.VId,this.N,this.EId,this.G,this.L,this.PN,this.uid,this.MTS);

  users.fromJson(var parsedJson) {
    this.em=parsedJson['em'];
    this.VId=parsedJson['VId'];
    this.N=parsedJson['N'];
    this.EId=parsedJson['EId'];
    this.G=parsedJson['G'];
    this.L=parsedJson['L'];
    this.PN=parsedJson['PN'];
    this.uid=parsedJson['uid'];
    this.MTS=parsedJson['MTS'];

  }


}