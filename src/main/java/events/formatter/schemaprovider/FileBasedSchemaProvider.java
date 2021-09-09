package events.formatter.schemaprovider;

import events.formatter.IProvideSchema;
import java.io.FileInputStream;
import java.io.InputStream;
import java.util.Map;
import org.apache.commons.io.IOUtils;
import org.springframework.core.io.Resource;

public class FileBasedSchemaProvider implements IProvideSchema {

  private Resource genericSchemaPath;
  private Map<String, String> specificSchemaPath;
  private boolean useGenericForMissing;

  public FileBasedSchemaProvider(Resource genericSchemaPath,
      Map<String, String> specificSchemaPath, boolean useGenericForMissing) {
    this.genericSchemaPath = genericSchemaPath;
    this.specificSchemaPath = specificSchemaPath;
    this.useGenericForMissing = useGenericForMissing;
  }

  public String getGenericSchema() throws Exception {
    InputStream inputStream = genericSchemaPath.getInputStream();
    return IOUtils.toString(inputStream, "UTF-8");
  }

  public String getSpecificSchemaFor(String messageName) throws Exception {
    if (!this.specificSchemaPath.containsKey(messageName)) {
      if (useGenericForMissing) {
        return this.getGenericSchema();
      }
      throw new Exception();
    }
    FileInputStream fis = new FileInputStream(this.specificSchemaPath.get(messageName));
    return IOUtils.toString(fis, "UTF-8");
  }
}
