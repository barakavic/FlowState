interface BookCardProps {
  title: string;
  pagesRead: number;
  totalPages: number;
  readingRate: number;
  onClick: () => void;
}

export function BookCard({
  title,
  pagesRead,
  totalPages,
  readingRate,
  onClick,
}: BookCardProps) {
  const daysRemaining = Math.ceil((totalPages - pagesRead) / readingRate);
  const progressPercent = (pagesRead / totalPages) * 100;

  return (
    <div
      onClick={onClick}
      className="bg-[#1a1d29] border border-[#2a2d3a] rounded-lg p-5 hover:border-[#3a3d4a] transition-colors cursor-pointer min-w-[280px]"
    >
      <h4 className="text-foreground mb-3">{title}</h4>

      <div className="space-y-2">
        <div className="flex justify-between text-sm">
          <span className="text-muted-foreground">Progress</span>
          <span className="text-foreground">
            {pagesRead} / {totalPages} pages
          </span>
        </div>

        <div className="w-full bg-[#2a2d3a] rounded-full h-1.5">
          <div
            className="bg-blue-500 h-1.5 rounded-full transition-all"
            style={{ width: `${progressPercent}%` }}
          />
        </div>

        <div className="flex justify-between text-xs text-muted-foreground pt-1">
          <span>{readingRate} pages/day</span>
          <span>~{daysRemaining} days left</span>
        </div>
      </div>
    </div>
  );
}
