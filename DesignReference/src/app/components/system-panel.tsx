import { AlertTriangle, ChevronDown, ChevronRight, CheckCircle2 } from "lucide-react";
import { useState } from "react";

interface Warning {
  message: string;
  severity: "high" | "medium";
}

interface SystemPanelProps {
  warnings: Warning[];
  backlogItems: string[];
  completedItems: string[];
}

export function SystemPanel({
  warnings,
  backlogItems,
  completedItems,
}: SystemPanelProps) {
  const [backlogOpen, setBacklogOpen] = useState(false);
  const [completedOpen, setCompletedOpen] = useState(false);

  return (
    <div className="w-[280px] bg-[#14161f] border-l border-[#2a2d3a] p-4 overflow-y-auto flex flex-col gap-6">
      {/* System Pressure */}
      <div>
        <div className="flex items-center gap-2 mb-3">
          <AlertTriangle className="w-4 h-4 text-amber-400" />
          <h3 className="text-sm text-foreground">System Pressure</h3>
        </div>

        {warnings.length === 0 ? (
          <div className="text-xs text-muted-foreground bg-green-500/5 border border-green-500/20 rounded p-3">
            All systems green
          </div>
        ) : (
          <div className="space-y-2">
            {warnings.map((warning, index) => (
              <div
                key={index}
                className={`text-xs rounded p-3 border ${
                  warning.severity === "high"
                    ? "bg-red-500/10 border-red-500/30 text-red-400"
                    : "bg-amber-500/10 border-amber-500/30 text-amber-400"
                }`}
              >
                {warning.message}
              </div>
            ))}
          </div>
        )}
      </div>

      {/* Backlog */}
      <div>
        <button
          onClick={() => setBacklogOpen(!backlogOpen)}
          className="flex items-center justify-between w-full text-sm text-muted-foreground hover:text-foreground transition-colors mb-2"
        >
          <span>Backlog ({backlogItems.length})</span>
          {backlogOpen ? (
            <ChevronDown className="w-4 h-4" />
          ) : (
            <ChevronRight className="w-4 h-4" />
          )}
        </button>

        {backlogOpen && (
          <div className="space-y-1">
            {backlogItems.map((item, index) => (
              <div
                key={index}
                className="text-xs text-foreground/50 py-2 px-2 rounded hover:bg-[#1a1d29] cursor-pointer transition-colors"
              >
                {item}
              </div>
            ))}
          </div>
        )}
      </div>

      {/* Completed */}
      <div>
        <button
          onClick={() => setCompletedOpen(!completedOpen)}
          className="flex items-center justify-between w-full text-sm text-muted-foreground hover:text-foreground transition-colors mb-2"
        >
          <span>Completed ({completedItems.length})</span>
          {completedOpen ? (
            <ChevronDown className="w-4 h-4" />
          ) : (
            <ChevronRight className="w-4 h-4" />
          )}
        </button>

        {completedOpen && (
          <div className="space-y-1">
            {completedItems.map((item, index) => (
              <div
                key={index}
                className="flex items-start gap-2 text-xs py-2 px-2 rounded hover:bg-[#1a1d29] cursor-pointer transition-colors"
              >
                <CheckCircle2 className="w-3 h-3 text-green-400 flex-shrink-0 mt-0.5" />
                <span className="text-foreground/50 line-through">{item}</span>
              </div>
            ))}
          </div>
        )}
      </div>
    </div>
  );
}
