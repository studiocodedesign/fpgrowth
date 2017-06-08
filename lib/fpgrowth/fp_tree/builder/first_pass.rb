module FpGrowth
  module FpTree
    module Builder
      class FirstPass

        attr_accessor :supports

        def initialize(threshold=1)

          @supports = Hash.new 0
          @threshold = threshold

        end


        # Scan data and find support for each item
        # @param transactions FpGrowth::Transaction
        #
        #
        def scan(transactions=@transactions)
          @supports= Hash.new(0)
          for transaction in transactions
            for item in transaction
              @supports[item] += 1
            end

          end
          return @supports
        end

        # discard unfrequent items
        # @param supports Hash
        #
        def pruning(transactions=@transactions, supports=@supports, threshold=@threshold)

          minimum = transactions.size.to_f / 100 * threshold
          for transaction in transactions
            transaction.delete_if { |item| supports[item] < minimum }
          end
          transactions.delete([])

          supports.delete_if { |key, value| value < minimum }
          return supports
        end

        # Ordonner les items en fonction de le support
        # Cet ordre est utilisé pour la construction du Tree lors de la seconde passe
        #
        def sort(supports=@supports)
          Hash[(supports.sort_by { |key, value| [-value, key] })]
        end

        # Actually make the first pass
        #
        def execute(transactions, threshold=@threshold)
          @transactions = transactions
          @threshold = threshold
          scan
          pruning
          sort
        end

      end
    end
  end
end
