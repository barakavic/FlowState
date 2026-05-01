import { ChevronDown, ChevronRight } from "lucide-react";
import { useState } from "react";

interface RightPanelProps {
  backlogItems: string[];
  completedItems: Array<{ title: string; completedDate: string }>;
}

export function RightPanel({ backlogItems, completedItems }: RightPanelProps) {
  const [backlogOpen, setBacklogOpen] = useState(true);
  const [completedOpen, setCompletedOpen] = useState(false);

  return (
    <div className="w-[20%] min-w-[200px] bg-[#14161f] border-l border-[#2a2d3a] p-4 overflow-y-auto">
      <div className="space-y-4">
        <div>
          <button
            onClick={() => setBacklogOpen(!backlogOpen)}
            className="flex items-center gap-2 text-sm text-muted-foreground hover:text-foreground transition-colors mb-3 w-full"
          >
            {backlogOpen ? (
              <ChevronDown className="w-4 h-4" />
            ) : (
              <ChevronRight className="w-4 h-4" />
            )}
            <span>Backlog ({backlogItems.length})</span>
          </button>

          {backlogOpen && (
            <div className="space-y-2">
              {backlogItems.map((item, index) => (
                <div
                  key={index}
                  className="text-sm text-foreground/60 py-1.5 px-2 rounded hover:bg-[#1a1d29] cursor-pointer transition-colors"
                >
                  {item}
                </div>
              ))}
            </div>
          )}
        </div>

        <div>
          <button
            onClick={() => setCompletedOpen(!completedOpen)}
            className="flex items-center gap-2 text-sm text-muted-foreground hover:text-foreground transition-colors mb-3 w-full"
          >
            {completedOpen ? (
              <ChevronDown className="w-4 h-4" />
            ) : (
              <ChevronRight className="w-4 h-4" />
            )}
            <span>Completed ({completedItems.length})</span>
          </button>

          {completedOpen && (
            <div className="space-y-2">
              {completedItems.map((item, index) => (
                <div
                  key={index}
                  className="py-1.5 px-2 rounded hover:bg-[#1a1d29] cursor-pointer transition-colors"
                >
                  <p className="text-sm text-green-400/80 line-through">
                    {item.title}
                  </p>
                  <p className="text-xs text-muted-foreground mt-0.5">
                    {item.completedDate}
                  </p>
                </div>
              ))}
            </div>
          )}
        </div>
      </div>
    </div>
  );
}
