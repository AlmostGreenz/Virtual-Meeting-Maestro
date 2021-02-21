public class VMMSystemAdapter extends VMMSystem {
  
  final ReaderGateway readerGateway = new ReaderGateway(VMMSystem.FILEPATH);
  final WriterGateway writerGateway = new WriterGateway(VMMSystem.FILEPATH);
  
  public VMMSystemAdapter() {
    try {
            if (!this.readerGateway.readFromFile(this.meetingManager)) {
                this.writerGateway.writeToFile();
            }
        } catch (InvalidFileFormatException e) {
            new UiBooster().showErrorDialog("The storage file's format is invalid.", "ERROR");
        }
  }
  
  void saveToFile() {
      writerGateway.writeToFile(meetingManager); //<>//
   }
}
