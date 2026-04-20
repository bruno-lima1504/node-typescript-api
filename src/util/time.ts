import moment from 'moment';
//TODO someone to implement a test for this util
export class TimeUtil {
  public static getUnixTimeForAFuteureDay(days: number): number {
    return moment().add(days, 'days').unix();
  }
}
