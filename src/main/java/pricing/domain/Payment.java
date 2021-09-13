package pricing.domain;

import java.util.UUID;
import lcp.Lcp;
import money.Money;

public class Payment {

  private UUID id;
  private Money value;
  private Money interChangeFee;
  private Money schemeFee;
  private Lcp lcp;

  public Payment(UUID id, Money value, Money interChangeFee, Money schemeFee, Lcp lcp) {
    this.id = id;
    this.value = value;
    this.interChangeFee = interChangeFee;
    this.schemeFee = schemeFee;
    this.lcp = lcp;
  }

  public UUID getId() {
    return id;
  }

  public Money getValue() {
    return value;
  }

  public Money getInterChangeFee() {
    return interChangeFee;
  }

  public Money getSchemeFee() {
    return schemeFee;
  }

  public Lcp getLcp() {
    return this.lcp;
  }
}
