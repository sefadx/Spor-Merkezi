export class BaseResponseModel {
  success: Boolean;
  message: String;
  data: any;

  // Normal signature with defaults
  constructor(status: Boolean, message: String, data?: any) {
    this.success = status;
    this.message = message;
    this.data = data;
  }

  toJson() {
    return {
      success: this.success,
      message: this.message,
      data: this.data,
    };
  }
}