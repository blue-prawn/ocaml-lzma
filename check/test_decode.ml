open Lzma

let load_file f =
  let ic = open_in_bin f in
  let n = in_channel_length ic in
  let s = Bytes.create n in
  really_input ic s 0 n;
  close_in ic;
  (s)

let filename = "./test_data.txt.lzma"

let buf_len = 16384

let () =
  Lzma.init ();
  let data = load_file filename in
  let data_len = Bytes.length data in
  let strm = new_lzma_stream () in
  let memlimit = 268_435_456L in  (* 256 * 1024 * 1024 *)
  lzma_auto_decoder ~strm ~check:LZMA_CHECK_NONE ~memlimit;
  let buf = Bytes.create buf_len in
  let ofs = ref 0 in
  begin
    try
      while true do
        let avail_in, avail_out =
          lzma_code ~strm ~action:LZMA_RUN
                    ~next_in:data ~next_out:buf
                    ~ofs_in:!ofs
                    ~ofs_out:0
        in
        ofs := data_len - avail_in;
        print_bytes buf;
      done
    with EOF n ->
      let str_end = Bytes.sub buf 0 (buf_len - n) in
      print_bytes str_end;
      lzma_end ~strm;
  end;
;;

