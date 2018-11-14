RSpec.shared_examples "standard nn ops evaluator" do
  extend SupportedOp

  let(:ts) { TensorStream }

  before(:each) do
    TensorStream::Tensor.reset_counters
    TensorStream::Operation.reset_counters
    tf.reset_default_graph
    sess.clear_session_cache
  end

  supported_op ".conv2d" do
    context "rgb" do
      # 2 RGB images
      let(:image) do
        [
          [[[0.14, 0.47, 0.20], [0.96, 0.10, 0.59], [0.65, 0.954, 0.023], [0.9461, 0.52, 0.701]],
          [[0.83, 0.101, 0.21], [0.91, 0.87, 0.96], [0.30, 0.01, 0.07], [0.95, 0.81, 0.36]],
          [[0.07, 0.95, 0.84], [0.23, 0.22, 0.68], [0.017, 0.16, 0.67], [0.78, 0.33, 0.51]],
          [[0.13, 0.77, 0.54], [0.65, 0.34, 0.19], [0.601, 0.41, 0.31], [0.26, 0.33, 0.07]]],

          [[[0.1, 0.47, 0.20], [0.5, 0.10, 0.59], [0.65, 0.954, 0.1], [0.9461, 0.2, 0.3]],
          [[0.2, 0.101, 0.21], [0.9, 0.87, 0.96], [0.30, 0.01, 0.07], [0.95, 0.81, 0.36]],
          [[0.3, 0.95, 0.84], [0.23, 0.22, 0.68], [0.017, 0.2, 0.67], [0.1, 0.33, 0.8]],
          [[0.13, 0.77, 0.54], [0.65, 0.34, 0.19], [0.601, 0.41, 0.9], [0.26, 0.33, 0.1]]]
        ].t
      end

      let(:sample_filter) do
        [
         [[[0.97, 0.38, 0.62], [0.88, 0.16, 0.899], [0.87, 0.06, 0.06]], [[0.14, 0.47, 0.33], [0.83, 0.095, 0.04], [0.47, 0.16, 0.29]]],
         [[[0.79, 0.55, 0.24], [0.075, 0.84, 0.77], [0.40, 0.72, 0.55]], [[0.43, 0.05, 0.42], [0.16, 0.62, 0.31], [0.07, 0.94, 0.99]]]
        ].t
      end

      it "calculates for convultion on a 2d image" do
        conv = ts.nn.conv2d(image, sample_filter, [1, 1, 1, 1], 'SAME')
        expect(image.shape.shape).to eq([2, 4, 4, 3])
        expect(sample_filter.shape.shape).to eq([2, 2, 3, 3])
        expect(conv.shape.shape).to eq([2, 4, 4, 3])
        result = sess.run(conv)
        expect(result).to eq([
          [
            [
              [2.563075, 2.87534      ,3.008], [3.7297802 , 2.82551   , 2.59453],   [3.2126038 , 2.119147  , 2.923029  ],   [2.9404368 , 1.946878  , 2.145822  ]
            ],
            [
              [3.0216298 , 3.23651   , 3.2797992 ], [3.1167102 , 2.2265, 2.8422701 ], [2.0525298 , 2.05, 2.08007   ], [2.7924502 , 1.5856    , 2.06059]
            ],
            [
              [2.8927498 , 1.9958    , 2.71735   ], [2.41911   , 1.6493399 , 1.7962099 ], [2.16203   , 1.73336   , 1.52432   ], [1.74885   , 0.8504    , 1.16587   ]
            ],
            [
              [1.7360001 , 0.5732    , 1.08843   ], [1.66514   , 0.68382   , 1.02469   ], [1.55667   , 0.47732997, 0.87911   ], [0.6035    , 0.15579998, 0.46207002]
            ]
          ],

          [
            [
              [1.957875  , 2.2969398 , 2.676],[3.31187   , 2.6575298 , 2.32926   ], [2.825524  , 2.029207  , 2.798559  ], [2.309967  , 1.8716179 , 1.8340819 ]
            ],
            [
              [2.5908298 , 3.11891   , 2.9410992 ], [3.11341   , 2.2475    , 2.8484702 ], [1.7834299 , 2.3222    , 2.11237   ],[2.3712502 , 1.4204001 , 2.05689   ]
            ],
            [
              [3.11585   , 2.0832    , 2.85995   ], [2.49361   , 2.2077398 , 2.3819098 ], [2.47643   , 1.91956   , 1.7741799 ], [1.3535501 , 0.63100004, 0.77817005]
            ],
            [
              [1.7360001 , 0.5732    , 1.08843   ], [1.94244   , 0.77822   , 1.19579   ], [2.08407   , 0.51752996, 0.92320997], [0.62960005, 0.15759999, 0.46387002]
            ]
          ]
      ])
      end
    end

    context "grayscale" do
      let(:image) do
        [
          [
            [[0.92], [0.58], [0.62], [0.98]],
            [[0.61], [0.56], [0.08], [0.99]],
            [[0.98], [0.18], [0.031], [0.74]],
            [[0.769], [0.79], [0.42], [0.057]]
          ],
          [
            [[0.63], [0.62], [0.10], [0.83]],
            [[0.808], [0.44], [0.67], [0.12]],
            [[0.21], [0.52], [0.19], [0.40]],
            [[0.04], [0.37], [0.51], [0.75]]
          ]
        ].t
      end

      let(:sample_filter) do
          [
            [[ [1.0] ], [ [0.5] ]],
            [[ [0.0] ], [ [0.2] ]],
          ].t
      end

      specify do
        expect(image.shape.shape).to eq([2, 4, 4, 1])
        expect(sample_filter.shape.shape).to eq([2, 2, 1, 1])
        conv = ts.nn.conv2d(image, sample_filter, [1, 1, 1, 1], 'SAME')
        expect(conv.shape.shape).to eq([2, 4, 4, 3])
        result = sess.run(conv)
        expect(result).to eq([
          [
            [[1.322], [0.906], [1.3080001 ],[0.98]],
            [[0.926], [0.6062],[0.723],[0.99]],
            [[1.228], [0.2795],[0.4124],[0.74]],
            [[1.164], [1.0], [0.44849998],[0.057]]
          ],

          [
            [[1.028], [0.804],[0.539],[0.83]],
            [[1.132], [0.81299996], [0.81],[0.12]],
            [[0.54399997],[0.717],[0.54],[0.4]],
            [[0.225],[0.625],[0.885],[0.75]]
          ]
        ])
      end
    end
  end
end