/**
 * An Adapter class which facilitates the interaction between Virtual_Meeting_Maestro.pde, ReaderGateway.pde, WriterGateway.pde, and VMMSystem.java.
 */
public class VMMSystemAdapter extends VMMSystem {
  
  final ReaderGateway readerGateway = new ReaderGateway(VMMSystem.FILEPATH);
  final WriterGateway writerGateway = new WriterGateway(VMMSystem.FILEPATH);
  
  /**
   * Constructs an instance of VMMSystemAdapter by reading in data from the storage file.
   */
  public VMMSystemAdapter() {
    try {
            if (!this.readerGateway.readFromFile(this.meetingManager)) {
                this.writerGateway.writeToFile();
            }
        } catch (InvalidFileFormatException e) {
            new UiBooster().showErrorDialog("The storage file's format is invalid.", "ERROR");
        }
  }
  
  /**
   * Save the Meeting instances' data to file.
   */
  void saveToFile() {
      writerGateway.writeToFile(meetingManager); //<>//
   }
}
