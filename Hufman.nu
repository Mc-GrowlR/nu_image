def is_leaf_node [
    node: record<weight, lc:record, lc:record>,
] {
    (($node.lc? | is-empty ) and ($node.rc? | is-empty))
}

def create_hufman_node [
    weight,
    lc: record = {},
    rc: record = {},
] {
    {
        weight: $weight,
        lc: $lc,
        rc: $rc,
    }
}

def create_hufman_tree [
    code_list: list,
] {
    mut Forest = ($code_list | par-each { |elt| create_hufman_node $elt } | sort-by weight)
    mut HufmanTree = {}
    mut i = 0
    while ($Forest | is-not-empty) {
        if $i >= 100 {
            break
        }
        $HufmanTree = ($Forest | first )
        $Forest = ($Forest | skip 1)

        if ($Forest | is-not-empty) {
            let SecondTree = ($Forest | first )
            $Forest = ($Forest | skip 1)
            let flag: bool =  ($HufmanTree.weight > $SecondTree.weight)
            $HufmanTree = (create_hufman_node ($HufmanTree.weight + $SecondTree.weight) (if $flag { $SecondTree } else { $HufmanTree }) (if $flag { $HufmanTree } else { $SecondTree }))
            $Forest = ($Forest ++ $HufmanTree | sort-by weight ) 
        }
        $i += 1
    }

    $HufmanTree
}

def main [] {
    let code_list = [0.1, 0.2, 0.3, 0.04, 0.06, 0.11, 0.18, 0.01]
    timeit {
        let hufman_tree = (create_hufman_tree $code_list)
    } 
}
