import { StreamActions } from "@hotwired/turbo";

import dispatch from "./dispatch_action";
StreamActions.dispatch = dispatch;
import removeClass from "./remove_class_action";
StreamActions.remove_class = removeClass;
