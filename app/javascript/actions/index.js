import { StreamActions } from "@hotwired/turbo";

import dispatch from "./dispatch_action";
StreamActions.dispatch = dispatch;
