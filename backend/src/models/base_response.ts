export class BaseResponseModel {
  status: Boolean;
  message: String;
  data: any;

  // Normal signature with defaults
  constructor(status: Boolean, message: String, data?: any) {
    this.status = status;
    this.message = message;
    this.data = data;
  }

  toJson() {
    return {
      status: this.status,
      message: this.message,
      data: this.data,
    };
  }
}