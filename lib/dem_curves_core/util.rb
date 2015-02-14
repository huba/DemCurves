class Integer
  def choose(k)
    # binominal coefficient
    return self.factorial / ((self -k).factorial * k.factorial)
  end
  
  def factorial()
    # n!
    return (1..self).inject(1, &:*)
  end
end

def bernstein_basis(i, n, t)
  # http://mathworld.wolfram.com/BernsteinPolynomial.html
  return n.choose(i) * t ** i * (1 - t) ** (n - i)
end

class Vector
  def unit
    return self / self.r
  end
  
  def angle(other)
    return Math.acos(self.inner_product other / (self.r * other.r))
  end
end