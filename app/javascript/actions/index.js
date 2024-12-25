import { StreamActions } from "@hotwired/turbo";

import dispatch from "actions/dispatch_action";
StreamActions.dispatch = dispatch;
import removeClass from "actions/remove_class_action";
StreamActions.remove_class = removeClass;
