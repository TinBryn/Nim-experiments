import pagenode, uri, locks, deques, sets

type
  Crawler* = object
    num_threads, max_threads: Natural
    verbose: bool
    domain: Uri
    lock: Lock
    queue{.guard: lock.}: Deque[Uri]
    current{.guard: lock.}: HashSet[Uri]
    errors{.guard: lock.}: seq[string]
    graph{.guard: lock.}: PageGraph

# constructor
proc newCrawler*(max_threads: int): Crawler =
  Crawler(num_threads: 0, max_threads: max_threads, verbose: false)

#
proc spawn_crawling_thread(self: var Crawler, uri: Uri) =
  withLock(self.lock):
    self.current.incl(uri)

# 
proc enqueue(self: var Crawler, uri: Uri) =
  withLock(self.lock):
    if self.graph.add_node(uri):
      echo "Enqueueing ", uri, " (queue has size ", self.queue.len
      if self.num_threads < self.max_threads:
        self.num_threads.inc
        self.spawn_crawling_thread(uri)
      else:
        self.queue.addLast(uri)

# main crawl method
proc crawl*(self: var Crawler, 
    start_url: string, display_results: bool): var PageGraph =
  self.domain = parse_uri(start_url)
  self.enqueue(self.domain)

  withLock(self.lock):
    return self.graph
