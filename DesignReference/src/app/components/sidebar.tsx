import { LayoutDashboard, FolderKanban, Book, CheckCircle } from "lucide-react";

interface SidebarProps {
  activeProjects: number;
  maxProjects: number;
  activeBooks: number;
  maxBooks: number;
  currentView: string;
  onNavigate: (view: string) => void;
}

export function Sidebar({
  activeProjects,
  maxProjects,
  activeBooks,
  maxBooks,
  currentView,
  onNavigate,
}: SidebarProps) {
  const navItems = [
    { id: "dashboard", label: "Dashboard", icon: LayoutDashboard },
    { id: "projects", label: "Projects", icon: FolderKanban },
    { id: "books", label: "Books", icon: Book },
    { id: "completed", label: "Completed", icon: CheckCircle },
  ];

  return (
    <div className="w-[20%] min-w-[200px] bg-[#14161f] border-r border-[#2a2d3a] p-4 flex flex-col">
      <nav className="space-y-1 mb-8">
        {navItems.map((item) => {
          const Icon = item.icon;
          const isActive = currentView === item.id;

          return (
            <button
              key={item.id}
              onClick={() => onNavigate(item.id)}
              className={`w-full flex items-center gap-3 px-3 py-2 rounded-md transition-colors ${
                isActive
                  ? "bg-blue-500/10 text-blue-400"
                  : "text-muted-foreground hover:bg-[#1a1d29] hover:text-foreground"
              }`}
            >
              <Icon className="w-4 h-4" />
              <span className="text-sm">{item.label}</span>
            </button>
          );
        })}
      </nav>

      <div className="mt-auto space-y-4">
        <div className="bg-[#1a1d29] border border-[#2a2d3a] rounded-lg p-3">
          <h4 className="text-xs text-muted-foreground mb-2">Active Projects</h4>
          <p className="text-foreground">
            {activeProjects} / {maxProjects}
          </p>
        </div>

        <div className="bg-[#1a1d29] border border-[#2a2d3a] rounded-lg p-3">
          <h4 className="text-xs text-muted-foreground mb-2">Active Books</h4>
          <p className="text-foreground">
            {activeBooks} / {maxBooks}
          </p>
        </div>
      </div>
    </div>
  );
}
